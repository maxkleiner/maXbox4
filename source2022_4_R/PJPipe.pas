{
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/
 *
 * Copyright (C) 2007-2013, Peter Johnson (www.delphidabbler.com).
 *
 * $Rev: 1315 $
 * $Date: 2013-03-21 13:44:28 +0000 (Thu, 21 Mar 2013) $
 *
 * Class that encapsulates an unamed pipe and can read and write the pipe.
}

unit PJPipe;

{$UNDEF COMPILERSUPPORTED}
{$UNDEF STRICT}
{$UNDEF RTLNAMESPACES}
{$IFDEF CONDITIONALEXPRESSIONS}
  {$IF CompilerVersion >= 15.0}   // >= Delphi 7
    {$DEFINE COMPILERSUPPORTED}
  {$IFEND}
  {$IF CompilerVersion >= 17.0}   // >= Delphi 2005
    {$DEFINE STRICT}
  {$IFEND}
  {$IF CompilerVersion >= 23.0}   // >= Delphi XE2
    {$DEFINE RTLNAMESPACES}
  {$IFEND}
{$ENDIF}

{$IFNDEF COMPILERSUPPORTED}
  {$MESSAGE FATAL 'Minimum compiler version is Delphi 7'}
{$ENDIF}

{$UNDEF RTLNAMESPACES}
{$IF CompilerVersion >= 23.0} // >= Delphi XE2
  {$DEFINE RTLNAMESPACES}
{$IFEND}

{$WARN UNSAFE_CODE OFF}

interface


uses
  // Delphi
  {$IFNDEF RTLNAMESPACES}
  SysUtils, Classes, Windows;
  {$ELSE}
  System.SysUtils, System.Classes, Winapi.Windows;
  {$ENDIF}


// Ensure TBytes is defined
{$IF not Declared(TBytes)}
type
  TBytes = array of Byte;
{$IFEND}

type

  ///  <summary>
  ///  Class that encapsulates an unamed pipe and can read and write the pipe.
  ///  </summary>
  TPJPipe = class(TObject)
  {$IFDEF STRICT}strict{$ENDIF}
  private
    ///  Handle used to read the pipe.
    fReadHandle: THandle;
    ///  Handle used to write the pipe.
    fWriteHandle: THandle;
    ///  <summary>Checks that the pipe's write handle hasn't been closed.
    ///  </summary>
    ///  <remarks>Raises EInOurError if handle is 0.</remarks>
    procedure CheckWriteHandle;
    ///  <summary>Creates a pipe using Windows API and records pipe handles.
    ///  </summary>
    ///  <param name="Size">Longword [in] Size of pipe. If 0 the default pipe
    ///  size is used.</param>
    ///  <param name="Security">PSecurityAttributes [in] Pointer to security
    ///  structure. May be nil.</param>
    ///  <remarks>Raises EInOutError if pipe can't be created.</remarks>
    procedure CreatePipe(const Size: LongWord;
      const Security: PSecurityAttributes);
  public
    ///  <summary>Object constructor. Creates a pipe with specified size.
    ///  </summary>
    ///  <param name="Size">LongWord [in] Required size of pipe. If Size is 0
    ///  then default pipe size used.</param>
    ///  <param name="Inheritable">Boolean [in] Indicates whether pipe handles
    ///  are to be inheritable.</param>
    ///  <remarks>Raises EInOutError if pipe can't be created.</remarks>
    constructor Create(const Size: LongWord; const Inheritable: Boolean = True);
      overload;
    ///  <summary>Object constructor. Creates a pipe object with default size.
    ///  </summary>
    ///  <param name="Inheritable">Boolean [in] Indicates whether pipe handles
    ///  are to be inheritable.</param>
    ///  <remarks>Raises EInOutError if pipe can't be created.</remarks>
    constructor Create(const Inheritable: Boolean = True);
      overload;
    ///  <summary>Object constructor. Creates a pipe object with specified size
    ///  and security.</summary>
    ///  <param name="Size">LongWord [in] Required size of pipe. If Size is 0
    ///  then default pipe size used.</param>
    ///  <param name="Security">TSecurityAttributes [in] Required security for
    ///  pipe. If handles to be inheritable set the bInheritHandle field to
    ///  true.</param>
    ///  <remarks>Raises EInOutError if pipe can't be created.</remarks>
    constructor Create(const Size: LongWord;
      const Security: TSecurityAttributes);
      overload;
    ///  <summary>Object constructor. Creates a pipe object with default size
    ///  pipe and specified security.</summary>
    ///  <param name="Security">TSecurityAttributes [in] Required security for
    ///  pipe. If handles to be inheritable set the bInheritHandle field to
    ///  true.</param>
    ///  <remarks>Raises EInOutError if pipe can't be created.</remarks>
    constructor Create(const Security: TSecurityAttributes);
      overload;
    ///  <summary>Object destructor. Tears down object.</summary>
    destructor Destroy; override;
    ///  <summary>Returns size of data, in bytes, available for reading from
    ///  pipe.</summary>
    ///  <remarks>EInOutError raised if there is an error peeking pipe.
    ///  </remarks>
    function AvailableDataSize: LongWord;
    ///  <summary>Reads data from pipe into a buffer.</summary>
    ///  <param name="Buf">Untyped [out] Buffer that receives data. Must have
    ///  capacity of at least BufSize bytes.</param>
    ///  <param name="BufSize">LongWord [in] Size of buffer or number of bytes
    ///  requested.</param>
    ///  <param name="BytesRead">LongWord [out] Receives number of bytes
    ///  actually read.</param>
    ///  <returns>True if some data was read, false if not.</returns>
    ///  <remarks>EInOutError raised if there is an error peeking or reading
    ///  pipe.</remarks>
    function ReadData(out Buf; const BufSize: LongWord;
      out BytesRead: LongWord): Boolean;
    ///  <summary>Reads data from pipe into a byte array.</summary>
    ///  <param name="Count">LongWord [in] Number of bytes to read from pipe. If
    ///  Count = 0 or greater than number of available bytes then all the data
    ///  from the pipe is read.</param>
    ///  <returns>Byte array containing data.</returns>
    ///  <remarks>EInOutError raised if there is an error peeking or reading
    ///  pipe.</remarks>
    function ReadBytes(const Count: LongWord = 0): TBytes;
    ///  <summary>Copies data from pipe to a stream.</summary>
    ///  <param name="Stm">TStream [in] Stream that receives data.</param>
    ///  <param name="Count">LongWord [in] Number of bytes to copy. If 0 then
    ///  all remaining data in pipe is copied to stream.</param>
    ///  <remarks>
    ///  <para>EInOutError raised if there is an error peeking or reading pipe.
    ///  </para>
    ///  <para>EWriteError raised if fail to write to stream.</para>
    ///  </remarks>
    procedure CopyToStream(const Stm: TStream; Count: LongWord = 0);
    ///  <summary>Copies data from a stream into the pipe.</summary>
    ///  <param name="Stm">TStream [in] Stream from which to copy data.</param>
    ///  <param name="Count">LongWord [in] Number of bytes to copy. If 0 then
    ///  all remaining data in stream is copied.</param>
    ///  <remarks>
    ///  <para>EInOutError raised if pipe's write handle has been closed or if
    ///  can't write to pipe.</para>
    ///  <para>EReadError raised if fail to read from stream.</para>
    ///  </remarks>
    procedure CopyFromStream(const Stm: TStream; Count: LongWord = 0);
    ///  <summary>Writes the whole content of a byte array to pipe.</summary>
    ///  <param name="Bytes">TBytes [in] Array of bytes to write to pipe.
    ///  </param>
    ///  <remarks>EInOutError raised if pipe's write handle has been closed or
    ///  if can't write to pipe.</remarks>
    procedure WriteBytes(const Bytes: TBytes);
    ///  <summary>Writes data from buffer to pipe.</summary>
    ///  <param name="Buf">Untyped [in] Buffer containing data to be written.
    ///  </param>
    ///  <param name="BufSize">LongWord [in] Number of bytes to write from
    ///  buffer. Buf must have capacity of at least BufSize bytes.</param>
    ///  <returns>Number of bytes actually written.</returns>
    ///  <remarks>EInOutError raised if pipe's write handle has been closed or
    ///  if can't write to pipe.</remarks>
    function WriteData(const Buf; const BufSize: LongWord): LongWord;
    ///  <summary>Closes the pipe's write handle if it is open.</summary>
    ///  <remarks>Closing the write handle effectively signals EOF to any reader
    ///  of the pipe. After calling this method no further data may be written
    ///  to the pipe.</remarks>
    procedure CloseWriteHandle;
    ///  <summary>Handle used to read data from the pipe. Should be non-zero.
    ///  </summary>
    property ReadHandle: THandle read fReadHandle;
    ///  <summary>Handle used to write data to the pipe. Should not be used
    ///  when 0.</summary>
    ///  <remarks>CloseWriteHandle closes and zeros this handle.</remarks>
    property WriteHandle: THandle read fWriteHandle;
  end;


implementation


resourcestring
  // Error messages
  sCantCreatePipe = 'Can''t create pipe: %s';
  sCantPeekPipe   = 'Can''t read pipe: peek attempt failed';
  sPipeReadError  = 'Error reading pipe';
  sBadWriteHandle = 'Can''t write pipe: handle closed';
  sPipeWriteError = 'Error writing pipe';


{ TPJPipe }

function TPJPipe.AvailableDataSize: LongWord;
begin
  if not PeekNamedPipe(fReadHandle, nil, 0, nil, @Result, nil) then
    raise EInOutError.Create(sCantPeekPipe);
end;

procedure TPJPipe.CheckWriteHandle;
begin
  if fWriteHandle = 0 then
    raise EInOutError.Create(sBadWriteHandle);
end;

procedure TPJPipe.CloseWriteHandle;
begin
  if fWriteHandle <> 0 then
  begin
    CloseHandle(fWriteHandle);
    fWriteHandle := 0;
  end;
end;

procedure TPJPipe.CopyFromStream(const Stm: TStream; Count: LongWord);
var
  BytesToWrite: LongWord;       // adjusted number of bytes to write
  Buf: array[0..4095] of Byte;  // buffer used in copying from pipe to stream
begin
  // Determine how much to copy
  if Count = 0 then
    Count := Stm.Size - Stm.Position;
  // Copy data one bufferful at a time
  while Count > 0 do
  begin
    if Count > SizeOf(Buf) then
      BytesToWrite := SizeOf(Buf)
    else
      BytesToWrite := Count;
    Stm.ReadBuffer(Buf, BytesToWrite);
    WriteData(Buf, BytesToWrite);
    Dec(Count, BytesToWrite);
  end;
end;

procedure TPJPipe.CopyToStream(const Stm: TStream; Count: LongWord);
var
  AvailBytes: LongWord;           // number of bytes in pipe
  BytesToRead: LongWord;          // decreasing count of remaining bytes
  BytesRead: LongWord;            // bytes read in each loop
  Buf: array[0..4095] of Byte;    // buffer used to read from stream
begin
  // Determine how much should be read
  AvailBytes := AvailableDataSize;
  if (Count = 0) or (Count > AvailBytes) then
    Count := AvailBytes;
  // Copy data one bufferful at a time
  while Count > 0 do
  begin
    if Count > SizeOf(Buf) then
      BytesToRead := SizeOf(Buf)
    else
      BytesToRead := Count;
    ReadData(Buf, BytesToRead, BytesRead);
    if BytesRead <> BytesToRead then
      raise EInOutError.Create(sPipeReadError);
    Stm.WriteBuffer(Buf, BytesRead);
    Dec(Count, BytesRead);
  end;
end;

constructor TPJPipe.Create(const Size: LongWord; const Inheritable: Boolean);
var
  Security: TSecurityAttributes;  // file's security attributes
begin
  inherited Create;
  if Inheritable then
  begin
    // Set up security structure so file handle is inheritable (for Windows NT)
    Security.nLength := SizeOf(Security);
    Security.lpSecurityDescriptor := nil;
    Security.bInheritHandle := True;
    CreatePipe(Size, @Security);
  end
  else
    CreatePipe(Size, nil);
end;

constructor TPJPipe.Create(const Size: LongWord;
  const Security: TSecurityAttributes);
begin
  inherited Create;
  CreatePipe(Size, @Security);
end;

constructor TPJPipe.Create(const Security: TSecurityAttributes);
begin
  Create(0, Security);
end;

constructor TPJPipe.Create(const Inheritable: Boolean);
begin
  Create(0, Inheritable);
end;

procedure TPJPipe.CreatePipe(const Size: LongWord;
  const Security: PSecurityAttributes);
begin
  {$IFNDEF RTLNAMESPACES}
  if not Windows.CreatePipe(fReadHandle, fWriteHandle, Security, Size) then
  {$ELSE}
  if not Winapi.Windows.CreatePipe(
    fReadHandle, fWriteHandle, Security, Size
  ) then
  {$ENDIF}
    raise EInOutError.CreateFmt(
      sCantCreatePipe, [SysErrorMessage(GetLastError)]
    );
end;

destructor TPJPipe.Destroy;
begin
  CloseHandle(fReadHandle);
  CloseWriteHandle;
  inherited;
end;

function TPJPipe.ReadBytes(const Count: LongWord): TBytes;
var
  AvailBytes: LongWord; // number of bytes in pipe
  BytesRead: LongWord;  // number of bytes actually read from pipe
begin
  AvailBytes := AvailableDataSize;
  if (Count = 0) or (Count > AvailBytes) then
    SetLength(Result, AvailBytes)
  else
    SetLength(Result, Count);
  ReadData(Pointer(Result)^, Length(Result), BytesRead);
  if BytesRead <> LongWord(Length(Result)) then
    raise EInOutError.Create(sPipeReadError);
end;

function TPJPipe.ReadData(out Buf; const BufSize: LongWord;
  out BytesRead: LongWord): Boolean;
var
  BytesToRead: DWORD;   // number of bytes to actually read
begin
  BytesToRead := AvailableDataSize;
  if BytesToRead > 0 then
  begin
    if BytesToRead > BufSize then
      BytesToRead := BufSize;
    // we don't check return value: sometimes fails with BytesRead = 0
    ReadFile(fReadHandle, Buf, BytesToRead, BytesRead, nil);
    Result := BytesRead > 0;
  end
  else
  begin
    Result := False;
    BytesRead := 0;
  end;
end;

procedure TPJPipe.WriteBytes(const Bytes: TBytes);
begin
  WriteData(Pointer(Bytes)^, Length(Bytes));
end;

function TPJPipe.WriteData(const Buf; const BufSize: LongWord): LongWord;
begin
  CheckWriteHandle;
  if not WriteFile(fWriteHandle, Buf, BufSize, Result, nil) then
    raise EInOutError.Create(sPipeWriteError);
end;

end.

