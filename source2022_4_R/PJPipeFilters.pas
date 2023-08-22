{
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/
 *
 * Copyright (C) 2011-2013, Peter Johnson (www.delphidabbler.com).
 *
 * $Rev: 1314 $
 * $Date: 2013-03-21 13:40:18 +0000 (Thu, 21 Mar 2013) $
 *
 * Classes that filter or format output from pipes.
}

unit PJPipeFilters;

{$UNDEF COMPILERSUPPORTED}
{$UNDEF ABSTRACTCLASSES}
{$UNDEF STRICT}
{$UNDEF RTLNAMESPACES}
{$IFDEF CONDITIONALEXPRESSIONS}
  {$IF CompilerVersion >= 15.0}   // >= Delphi 7
    {$DEFINE COMPILERSUPPORTED}
  {$IFEND}
  {$IF CompilerVersion >= 17.0}   // >= Delphi 2005
    {$DEFINE STRICT}
  {$IFEND}
  {$IF CompilerVersion >= 18.0}   // >= Delphi 2006
    {$DEFINE ABSTRACTCLASSES}
  {$IFEND}
  {$IF CompilerVersion >= 23.0}   // >= Delphi XE2
    {$DEFINE RTLNAMESPACES}
  {$IFEND}
{$ENDIF}

{$IFNDEF COMPILERSUPPORTED}
  {$MESSAGE FATAL 'Minimum compiler version is Delphi 7'}
{$ENDIF}

{$WARN UNSAFE_CODE OFF}

interface

uses
  {$IFNDEF RTLNAMESPACES}
  // Delphi
  SysUtils, Classes,
  {$ELSE}
  System.SysUtils, System.Classes,
  {$ENDIF}
  // Project
  PJPipe;

// Ensure TBytes is declared
{$IF not Declared(TBytes)}
type
  TBytes = array of Byte;
{$IFEND}
// Ensure UnicodeString is declared
{$IF not Declared(UnicodeString)}
type
  UnicodeString = WideString;
{$IFEND}

type
  ///  <summary>
  ///  Abstract base class for all classes that filter data read from pipes.
  ///  </summary>
  TPJPipeFilter = class{$IFDEF ABSTRACTCLASSES} abstract{$ENDIF}(TObject)
  {$IFDEF STRICT}strict{$ENDIF}
  private
    ///  Pipe that provides data
    fPipe: TPJPipe;
    ///  Indicates if pipe is owned (and freed) by this object
    fOwnsPipe: Boolean;
    ///  Buffer containing left over data not processed after last pipe read.
    fUnprocessedData: TBytes;
  {$IFDEF STRICT}strict{$ENDIF}
  protected
    ///  <summary>Returns number of bytes at end of RawData that cannot be
    ///  processed yet.</summary>
    ///  <remarks>Any such bytes are stored for use on next pipe read.</remarks>
    function LeftOverByteCount(const RawData: TBytes): Integer; virtual;
      abstract;
    ///  <summary>Performs filtering operation on given data.</summary>
    procedure DoFilter(const ValidData: TBytes); virtual; abstract;
    ///  <summary>Flushes any remaining data, assuming there is no more to come.
    ///  </summary>
    procedure DoFlush; virtual; abstract;
    ///  <summary>Processes given new Data.</summary>
    procedure ProcessData(const Data: TBytes);
  public
    ///  <summary>Object constructor. Records parameters.</summary>
    ///  <param name="APipe">TPJPipe [in] Pipe that provides data to be
    ///  filtered.</param>
    ///  <param name="AOwnsPipe">Boolean [in] Flag true if this object is to
    ///  own (and free) APipe.</param>
    constructor Create(const APipe: TPJPipe; const AOwnsPipe: Boolean = False);
    ///  <summry>Object destructor. Tears down object and performs flush
    ///  operation.</summary>
    destructor Destroy; override;
    ///  <summary>Reads all available data from pipe.</summary>
    procedure ReadPipe;
    ///  <summary>Flushes any unprocessed data.</summary>
    procedure Flush;
    ///  <summary>Checks if object currently contains any un processed data.
    ///  </summary>
    ///  <remarks>Call this after last call to AddData to test if there is any
    ///  data left un-processed. If so the data stream is not valid Unicode.
    ///  </remarks>
    function HaveUnprocessedData: Boolean;
    ///  <summary>Read only property providing access to pipe that is being
    ///  filtered.</summary>
    property Pipe: TPJPipe read fPipe;
  end;

type
  ///  <summary>Type of text read event triggered by classes that read Unicode
  ///  strings from pipes.</summary>
  ///  <param name="Sender">TObject [in] Object that triggers event.</param>
  ///  <param name="Text">UnicodeString [in] Text for which event was triggered.
  ///  </param>
  ///  <remarks>Type of OnText and OnLineEnd events.</remarks>
  TPJUnicodeTextReadEvent = procedure(Sender: TObject;
    const Text: UnicodeString) of object;

type
  ///  <summary>
  ///  Constructs valid Unicode BMP strings from chunks of data read from pipe.
  ///  Chunk may or may not be split on valid Unicode character boundaries. An
  ///  event is triggered for each string read. Strings are also parsed into
  ///  lines that are split by a specified end of line marker.
  ///  </summary>
  ///  <remarks>
  ///  <para>The class only works for Unicode text from the basic multingual
  ///  plane (BMP).</para>
  ///  <para>For info about the BMP see http://bit.ly/f3Ardu</para>
  ///  </remarks>
  TPJUnicodeBMPPipeFilter = class(TPJPipeFilter)
  {$IFDEF STRICT}strict{$ENDIF}
  private
    ///  Text data buffered awaiting next end of line.
    fPartialLine: UnicodeString;
    ///  Stores reference to OnText event handler.
    fOnText: TPJUnicodeTextReadEvent;
    ///  Stores reference to OnLineEnd event handler.
    fOnLineEnd: TPJUnicodeTextReadEvent;
    ///  Value of EOLMarker property.
    fEOLMarker: UnicodeString;
    ///  <summary>Triggers OnText event for a given Unicode string.</summary>
    procedure DoText(const Text: UnicodeString);
    ///  <summary>Triggers OnLineEnd event for a given Unicode string.</summary>
    procedure DoLineEnd(const Text: UnicodeString);
  {$IFDEF STRICT}strict{$ENDIF}
  protected
    ///  <summary>Returns number of bytes at end of RawData that cannot be
    ///  processed yet.</summary>
    ///  <remarks>Bytes that can't be processed are fragments of a Unicode
    ///  character.</remarks>
    function LeftOverByteCount(const RawData: TBytes): Integer; override;
    ///  <summary>Extracts Unicode text from given data and parses it into
    ///  lines.</summary>
    procedure DoFilter(const ValidData: TBytes); override;
    ///  <summary>Flushes any un-reported line of text, triggering OnLineEnd
    ///  event for it.</summary>
    procedure DoFlush; override;
  public
    ///  <summary>Sets default property values.</summary>
    procedure AfterConstruction; override;
    ///  <summary>Character(s) to be used as end of line marker used when
    ///  parsing text into lines.</summary>
    ///  <remarks>Defaults to CRLF (#13#10).</remarks>
    property EOLMarker: UnicodeString read fEOLMarker write fEOLMarker;
    ///  <summary>Event triggered whenever valid text is read from pipe.
    ///  Contains text up to and including last valid Unicode character in given
    ///  data.</summary>
    property OnText: TPJUnicodeTextReadEvent read fOnText write fOnText;
    ///  <summary>Event triggered when each end of line is reached. Also
    ///  triggered for any pending text when Flush is called, or object is
    ///  destroyed.</summary>
    property OnLineEnd: TPJUnicodeTextReadEvent
      read fOnLineEnd write fOnLineEnd;
  end;

type
  ///  <summary>Type of text read event triggered by classes that read Ansi
  ///  strings from pipes.</summary>
  ///  <param name="Sender">TObject [in] Object that triggers event.</param>
  ///  <param name="Text">AnsiString [in] Text for which event was triggered.
  ///  </param>
  ///  <remarks>Type of OnText and OnLineEnd events.</remarks>
  TPJAnsiTextReadEvent = procedure(Sender: TObject;
    const Text: AnsiString) of object;

type
  ///  <summary>
  ///  Constructs valid ANSI SBCS strings from chunks of data read from pipe. An
  ///  event is triggered for each string read. Strings are also parsed into
  ///  lines that are split by a specified end of line marker.
  ///  </summary>
  ///  <remarks>
  ///  <para>The class only works for Single Byte Character Set (SBCS) strings,
  ///  i.e. those that take exactly one byte per character. It is the caller's
  ///  responsibility to interpret the string's code page correctly.</para>
  ///  <para>For info about SBCS see http://bit.ly/epPKtW</para>
  ///  </remarks>
  TPJAnsiSBCSPipeFilter = class(TPJPipeFilter)
  {$IFDEF STRICT}strict{$ENDIF}
  private
    ///  Text data buffered awaiting next end of line.
    fPartialLine: AnsiString;
    ///  Stores reference to OnText event handler.
    fOnText: TPJAnsiTextReadEvent;
    ///  Stores reference to OnLineEnd event handler.
    fOnLineEnd: TPJAnsiTextReadEvent;
    ///  Value of EOLMarker property.
    fEOLMarker: AnsiString;
    ///  <summary>Triggers OnText event for a given ANSI string.</summary>
    procedure DoText(const Text: AnsiString);
    ///  <summary>Triggers OnLineEnd event for a given ANSI string.</summary>
    procedure DoLineEnd(const Text: AnsiString);
  {$IFDEF STRICT}strict{$ENDIF}
  protected
    ///  <summary>Returns number of bytes at end of RawData that cannot be
    ///  processed yet.</summary>
    ///  <remarks>All bytes can always be processed in a SBCS string, so this
    ///  method always returns 0.</remarks>
    function LeftOverByteCount(const RawData: TBytes): Integer; override;
    ///  <summary>Extracts ANSI text from given data and parses it into lines.
    ///  </summary>
    procedure DoFilter(const ValidData: TBytes); override;
    ///  <summary>Flushes any un-reported line of text, triggering OnLineEnd
    ///  event for it.</summary>
    procedure DoFlush; override;
  public
    ///  <summary>Sets default property values.</summary>
    procedure AfterConstruction; override;
    ///  <summary>Character(s) to be used as end of line marker used when
    ///  parsing text into lines.</summary>
    ///  <remarks>Defaults to CRLF (#13#10).</remarks>
    property EOLMarker: AnsiString read fEOLMarker write fEOLMarker;
    ///  <summary>Event triggered whenever text is read from pipe. Contains text
    ///  up to and including last ANSI character in given data.</summary>
    property OnText: TPJAnsiTextReadEvent read fOnText write fOnText;
    ///  <summary>Event triggered when each end of line is reached. Also
    ///  triggered for any pending text when Flush is called, or object is
    ///  destroyed.</summary>
    property OnLineEnd: TPJAnsiTextReadEvent
      read fOnLineEnd write fOnLineEnd;
  end;

implementation

{ TPJPipeFilter }

constructor TPJPipeFilter.Create(const APipe: TPJPipe;
  const AOwnsPipe: Boolean);
begin
  Assert(Assigned(APipe));
  inherited Create;
  fPipe := APipe;
  fOwnsPipe := AOwnsPipe;
end;

destructor TPJPipeFilter.Destroy;
begin
  DoFlush;
  if fOwnsPipe then
    fPipe.Free;
  inherited;
end;

procedure TPJPipeFilter.Flush;
begin
  DoFlush;
end;

function TPJPipeFilter.HaveUnprocessedData: Boolean;
begin
  Result := Length(fUnprocessedData) > 0;
end;

procedure TPJPipeFilter.ProcessData(const Data: TBytes);
var
  Buffer: TBytes;
  TrimmedByteCount: Integer;
begin
  if Length(Data) = 0 then
    Exit;
  SetLength(Buffer, Length(fUnprocessedData) + Length(Data));
  if Length(fUnprocessedData) > 0 then
    Move(fUnprocessedData[0], Buffer[0], Length(fUnprocessedData));
  Move(Data[0], Buffer[Length(fUnprocessedData)], Length(Data));
  TrimmedByteCount := LeftOverByteCount(Buffer);
  if TrimmedByteCount > 0 then
  begin
    fUnprocessedData := Copy(
      Buffer, Length(Buffer) - TrimmedByteCount, TrimmedByteCount
    );
    SetLength(Buffer, Length(Buffer) - TrimmedByteCount);
  end
  else
    SetLength(fUnprocessedData, 0);
  DoFilter(Buffer);
end;

procedure TPJPipeFilter.ReadPipe;
begin
  ProcessData(fPipe.ReadBytes(0));
end;

{ TPJUnicodeBMPPipeFilter }

procedure TPJUnicodeBMPPipeFilter.AfterConstruction;
begin
  inherited;
  fEOLMarker := #13#10;
end;

procedure TPJUnicodeBMPPipeFilter.DoFilter(const ValidData: TBytes);
var
  Text: UnicodeString;  // Text read from ValidData
  EOLPos: Integer;      // Position(s) of end of line marker in text
begin
  // Create Unicode text from data
  {$IFDEF UNICODE}
  Text := TEncoding.Unicode.GetString(ValidData);
  {$ELSE}
  // each character is exactly SizeOf(WideChar) bytes in basic multilingual
  // plane
  SetLength(Text, Length(ValidData) div SizeOf(WideChar));
  Move(Pointer(ValidData)^, Pointer(Text)^, Length(ValidData));
  {$ENDIF}
  // Trigger OnText event for read text
  DoText(Text);
  fPartialLine := fPartialLine + Text;
  // Break text into lines separated by EOLMarker, trigger OnLineEnd for each
  EOLPos := Pos(fEOLMarker, fPartialLine);
  while EOLPos > 0 do
  begin
    DoLineEnd(Copy(fPartialLine, 1, EOLPos - 1));
    fPartialLine := Copy(
      fPartialLine, EOLPos + Length(fEOLMarker), MaxInt
    );
    EOLPos := Pos(fEOLMarker, fPartialLine);
  end;
end;

procedure TPJUnicodeBMPPipeFilter.DoFlush;
begin
  if fPartialLine <> '' then
  begin
    DoLineEnd(fPartialLine);
    fPartialLine := '';
  end;
end;

procedure TPJUnicodeBMPPipeFilter.DoLineEnd(const Text: UnicodeString);
begin
  if Assigned(OnLineEnd) then
    OnLineEnd(Self, Text);
end;

procedure TPJUnicodeBMPPipeFilter.DoText(const Text: UnicodeString);
begin
  if Assigned(OnText) then
    OnText(Self, Text);
end;

function TPJUnicodeBMPPipeFilter.LeftOverByteCount(
  const RawData: TBytes): Integer;
begin
  Result := Length(RawData) mod SizeOf(WideChar);
end;

{ TPJAnsiSBCSPipeFilter }

procedure TPJAnsiSBCSPipeFilter.AfterConstruction;
begin
  inherited;
  fEOLMarker := #13#10;
end;

procedure TPJAnsiSBCSPipeFilter.DoFilter(const ValidData: TBytes);
var
  Text: AnsiString;  // Text read from ValidData
  EOLPos: Integer;   // Position(s) of end of line marker in text
begin
  // NOTE: code assumes SizeOf(AnsiChar) = 1
  // Record ANSI SBCS text
  SetLength(Text, Length(ValidData));
  Move(Pointer(ValidData)^, Pointer(Text)^, Length(ValidData));
  // Trigger OnText event for read text
  DoText(Text);
  fPartialLine := fPartialLine + Text;
  // Break text into lines separated by EOLMarker, trigger OnLineEnd for each
  EOLPos := Pos(fEOLMarker, fPartialLine);
  while EOLPos > 0 do
  begin
    DoLineEnd(Copy(fPartialLine, 1, EOLPos - 1));
    fPartialLine := Copy(
      fPartialLine, EOLPos + Length(fEOLMarker), MaxInt
    );
    EOLPos := Pos(fEOLMarker, fPartialLine);
  end;
end;

procedure TPJAnsiSBCSPipeFilter.DoFlush;
begin
  if fPartialLine <> '' then
  begin
    DoLineEnd(fPartialLine);
    fPartialLine := '';
  end;
end;

procedure TPJAnsiSBCSPipeFilter.DoLineEnd(const Text: AnsiString);
begin
  if Assigned(OnLineEnd) then
    OnLineEnd(Self, Text);
end;

procedure TPJAnsiSBCSPipeFilter.DoText(const Text: AnsiString);
begin
  if Assigned(OnText) then
    OnText(Self, Text);
end;

function TPJAnsiSBCSPipeFilter.LeftOverByteCount(
  const RawData: TBytes): Integer;
begin
  // all bytes are valid because each character is exactly one byte in a SBCS
  Result := 0;
end;

end.

