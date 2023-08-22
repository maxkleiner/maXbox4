{
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/
 *
 * Copyright (C) 2001-2014, Peter Johnson (www.delphidabbler.com).
 *
 * $Rev: 1515 $
 * $Date: 2014-01-11 02:36:28 +0000 (Sat, 11 Jan 2014) $
 *
 * Classes which provides various implementations of the IStream interface.
}


unit PJIStreams;


{$UNDEF SUPPORTS_STRICT}
{$UNDEF SUPPORTS_TSTREAM64}
{$UNDEF RTLNAMESPACES}
{$IFDEF CONDITIONALEXPRESSIONS}
  {$IF CompilerVersion >= 24.0} // Delphi XE3 and later
    {$LEGACYIFEND ON}  // NOTE: this must come before all $IFEND directives
  {$IFEND}
  {$IF CompilerVersion >= 23.0} // Delphi XE2 and later
    {$DEFINE RTLNAMESPACES}
  {$IFEND}
  {$IF CompilerVersion >= 18.0} // Delphi 2006 and later
    {$DEFINE SUPPORTS_STRICT}
  {$IFEND}
  {$IF CompilerVersion >= 15.0} // Delphi 7 and later
    {$WARN UNSAFE_CODE OFF}
    {$WARN UNSAFE_CAST OFF}
  {$IFEND}
  {$IF CompilerVersion >= 14.0} // Delphi 6 and later
    {$DEFINE SUPPORTS_TSTREAM64}
  {$IFEND}
{$ENDIF}


interface


uses
  // Delphi
  {$IFNDEF RTLNAMESPACES}
  Classes, Windows, ActiveX;
  {$ELSE}
  System.Classes, Winapi.Windows, Winapi.ActiveX;
  {$ENDIF}

type

  ///  <summary>
  ///  Class that implements the IStream interface for a wrapped TStream object.
  ///  </summary>
  TPJIStreamWrapper = class(TInterfacedObject, IStream)
  {$IFDEF SUPPORTS_STRICT}strict{$ENDIF}
  private
    ///  <summary>Flags if wrapped stream is freed in destructor.</summary>
    fCloseStream: Boolean;
    ///  <summary>Reference to wrapped stream.</summary>
    fBaseStream: TStream;
  {$IFDEF SUPPORTS_STRICT}strict{$ENDIF}
  protected
    ///  <summary>Returns name of stream.</summary>
    ///  <remarks>
    ///  <para>The name returned by this method is used as the value of the
    ///  pwcsName field of the statstg parameter returned from the Stat method.
    ///  </para>
    ///  <para>This implementation returns a name composed from the name of this
    ///  class (or desecendants) and the name of the wrapped TStream class.
    ///  </para>
    ///  <para>Descendant classes can override this method if they use a
    ///  different name for the stream.</para>
    ///  </remarks>
    function GetStreamNameAsString: string; virtual;

    ///  <summary>Uses the task allocator to allocate memory for name of stream
    ///  as a wide string and returns a pointer to it.</summary>
    ///  <remarks>
    ///  <para>Used by Stat method. Caller of stat method must use the task
    ///  allocator free the memory.</para>
    ///  <para>This method can be overridden if there is a need to change the
    ///  allocation method. To change the name returned, override
    ///  GetStreamNameAsString instead.</para>
    ///  </remarks>
    function GetStreamName: POleStr; virtual;

    ///  <summary>Reference to wrapped TStream object.</summary>
    property BaseStream: TStream read fBaseStream;

  public
    ///  <summary>Object constructor. Creates object that wraps a TStream
    ///  instance and provides an IStream interface to it.</summary>
    ///  <param name="Stream">TStream [in] Stream to be wrapped.</param>
    ///  <param name="CloseStream">Boolean [in] When True wrapped stream is
    ///  destroyed when this object is destroyed. When False user is responsible
    ///  for managing wrapped stream's lifetime.</param>
    constructor Create(const Stream: TStream;
      const CloseStream: Boolean = False);

    ///  <summary>Object destructor. Frees wrapped stream if CloseStream
    ///  parameter to constructor was True.</summary>
    destructor Destroy; override;

    ///  <summary>Reads data from the wrapped stream.</summary>
    ///  <param name="pv">Pointer [in] Pointer to buffer that receives data
    ///  read from wrapped stream.</param>
    ///  <param name="cb">Longint [in] Number of bytes to read.</param>
    ///  <param name="pcbRead">PLongint [in] Pointer to variable that receives
    ///  number of bytes actually read. May be nil if value not required.
    ///  </param>
    ///  <returns>HResult. S_OK on success, S_FAIL on error reading stream or
    ///  STG_E_INVALIDPOINTER if pv is nil.</returns>
    ///  <remarks>Method of IStream interface.</remarks>
    function Read(pv: Pointer; cb: Longint; pcbRead: PLongint): HResult;
      virtual; stdcall;

    ///  <summary>Writes data to the wrapped stream.</summary>
    ///  <param name="cb">Pointer [in] Pointer to buffer containing data to be
    ///  written.</param>
    ///  <param name="cb">Longint [in] Number of bytes to write.</param>
    ///  <param name="pcbWritten">PLongint [in] Pointer to variable that
    ///  receives number of bytes actually written. May be nil if value not
    ///  required.</param>
    ///  <returns>HResult. S_OK on success, STG_E_CANTSAVE if the stream can't
    ///  be written to or STG_E_INVALIDPOINTER if pv is nil.</returns>
    ///  <remarks>Method of IStream interface.</remarks>
    function Write(pv: Pointer; cb: Longint; pcbWritten: PLongint): HResult;
      virtual; stdcall;

    ///  <summary>Changes position of wrapped stream's seek pointer.</summary>
    ///  <param name="dlibMove">Largeint [in] Number of bytes to move seek
    ///  pointer relative to origin specified by dwOrigin.</param>
    ///  <param name="dwOrigin">Longint [in] Flag that determines origin from
    ///  which seek pointer is moved: STREAM_SEEK_SET to move from start of
    ///  stream, STREAM_SEEK_CUR to move relative to current position or
    ///  STREAM_SEEK_END to move from end of stream.</param>
    ///  <param name="libNewPosition">Largeint [out] Set to new position of
    ///  seek pointer.</param>
    ///  <returns>HResult. S_OK on success, STG_E_INVALIDPOINTER if the seek
    ///  fails or STG_E_INVALIDFUNCTION if an invalid origin was specified.
    ///  </returns>
    ///  <remarks>Method of IStream interface.</remarks>
    function Seek(dlibMove: Largeint; dwOrigin: Longint;
      out libNewPosition: Largeint): HResult; virtual; stdcall;

    ///  <summary>Changes size of wrapped stream.</summary>
    ///  <param name="libNewSize">Largeint [in] Required size.</param>
    ///  <returns>HResult. S_OK on success, E_FAIL if we can't set the size or
    ///  the requested size is too large or E_UNEXPECTED if an exception is
    ///  raised by the wrapped stream.</returns>
    ///  <remarks>Method of IStream interface.</remarks>
    function SetSize(libNewSize: Largeint): HResult; virtual; stdcall;

    ///  <summary>Copies data from wrapped stream to another stream.</summary>
    ///  <param name="stm">IStream [in] Reference to stream to receive copied
    ///  data.</param>
    ///  <param name="cb">Largeint [in] Number of bytes to be copied.</param>
    ///  <param name="cbRead">Largeint [out] Set to number of bytes actually
    ///  read from wrapped stream.</param>
    ///  <param name="cbWritten">Largeint [out] Set to number of bytes actually
    ///  written to stm.</param>
    ///  <returns>HResult. S_OK on success, E_UNEXPECTED if an exception was
    ///  raised in the wrapped stream during copying, STG_E_INVALIDPOINTER if
    ///  stm is nil, STG_E_CANTSAVE if the data can't be written to the
    ///  destination stream or STG_E_MEDIUMFULL if less than the requested
    ///  amount of data can be written to the destination stream.</returns>
    ///  <remarks>Method of IStream interface.</remarks>
    function CopyTo(stm: IStream; cb: Largeint; out cbRead: Largeint;
      out cbWritten: Largeint): HResult; virtual; stdcall;

    ///  <summary>Commits any pending changes to streams opened in transacted
    ///  mode. In direct mode buffers are simply flushed.</summary>
    ///  <param name="grfCommitFlags">Longint [in] Ignored.</param>
    ///  <remarks>
    ///  <para>Since wrapped TStream objects do not support transacted mode and
    ///  have no buffers to flush, this method is implemented as a no-op.</para>
    ///  <para>Method of IStream interface.</para>
    ///  <returns>HResult. S_OK.</returns>
    ///  </remarks>
    function Commit(grfCommitFlags: Longint): HResult; virtual; stdcall;

    ///  <summary>Discards all changes to a stream opened in transacted mode
    ///  since last call to Commit. Does nothing on streams opened in direct
    ///  mode.</summary>
    ///  <remarks>
    ///  <para>Since wrapped TStream objects do not support transacted mode this
    ///  method is implemented as a no-op.</para>
    ///  <para>Method of IStream interface.</para>
    ///  <returns>HResult. STG_E_REVERTED.</returns>
    ///  </remarks>
    function Revert: HResult; virtual; stdcall;

    ///  <summary>Not implemented. Always returns STG_E_INVALIDFUNCTION.
    ///  </summary>
    ///  <remarks>
    ///  <para>Method of IStream interface.</para>
    ///  <para>According to IStream documentation implementation of this method
    ///  is optional.</para>
    ///  </remarks>
    function LockRegion(libOffset: Largeint; cb: Largeint;
      dwLockType: Longint): HResult; virtual; stdcall;

    ///  <summary>Not implemented. Always returns STG_E_INVALIDFUNCTION.
    ///  </summary>
    ///  <remarks>
    ///  <para>Method of IStream interface.</para>
    ///  <para>According to IStream documentation implementation of this method
    ///  is optional.</para>
    ///  </remarks>
    function UnlockRegion(libOffset: Largeint; cb: Largeint;
      dwLockType: Longint): HResult; virtual; stdcall;

    ///  <summary>Retrieves a structure that provides information about the
    ///  wrapped stream.</summary>
    ///  <param name="statstg">TStatStg [out] Receives information about the
    ///  stream.</param>
    ///  <param name="grfStatFlag">Longint [in] Specifies which members of
    ///  statstg are not to receive information. Values are STATFLAG_DEFAULT
    ///  that omits the stream name from statstg or STATFLAG_NORMAL to include
    ///  include the stream.</param>
    ///  <returns>HResult. S_OK on success, E_UNEXPECTED if an exception occurs
    ///  in the wrapped stream, STG_E_INVALIDFLAG if grfStatFlag is not valid or
    ///  STG_E_INVALIDPOINTER if statstg is not a valid pointer.</returns>
    ///  <remarks>
    ///  <para>If grfStatFlag is STATFLAG_NORMAL then the pwcsName field of
    ///  statstg must be freed by the caller using the task allocator.</para>
    ///  <para>Only the dwType and pwcsName fields of statstg are given values.
    ///  All other fields are set to zero because they have no meaning in this
    ///  implementation. Descendant classes may add further information.</para>
    ///  <para>The value of the pwcsName field, when set, is determined by the
    ///  string returned from the GetStreamNameAsString method.</para>
    ///  <para>Method of IStream interface.</para>
    ///  </remarks>
    function Stat(out statstg: TStatStg; grfStatFlag: Longint): HResult;
      virtual; stdcall;

    ///  <summary>Not implemented. Always returns E_NOTIMPL.</summary>
    ///  <remarks>Method of IStream interface.</remarks>
    ///  <remarks>
    ///  <para>Method of IStream interface.</para>
    ///  <para>Implementation of this method on TStream objects is non-trivial
    ///  and has not been provided. Clone is simply implemented as a no-op.
    ///  </para>
    ///  </remarks>
    function Clone(out stm: IStream): HResult; virtual; stdcall;
  end;

type
  ///  <summary>
  ///  Class that implements an IStream interface for a wrapped THandleStream
  ///  object (including descendants such as TFileStream).
  ///  </summary>
  ///  <remarks>
  ///  Acts in a similar way to TPJIStreamWrapper except that file date stamps
  ///  are returned by the Stat method.
  ///  </remarks>
  TPJHandleIStreamWrapper = class(TPJIStreamWrapper, IStream)
  public
    ///  <summary>Object constructor. Creates object that wraps a THandleStream
    ///  instance and provides an IStream interface to it.</summary>
    ///  <param name="Stream">THandleStream [in] Stream to be wrapped.</param>
    ///  <param name="CloseStream">Boolean [in] When True wrapped stream is
    ///  destroyed when this object is destroyed. When False user is responsible
    ///  for managing wrapped stream's lifetime.</param>
    constructor Create(const Stream: THandleStream;
      const CloseStream: Boolean = False);

    ///  <summary>Retrieves a structure that provides information about the
    ///  wrapped stream.</summary>
    ///  <param name="statstg">TStatStg [out] Receives information about the
    ///  stream.</param>
    ///  <param name="grfStatFlag">Longint [in] Specifies which members of
    ///  statstg are not to receive information. Values are STATFLAG_DEFAULT
    ///  that omits the stream name from statstg or STATFLAG_NORMAL to include
    ///  include the stream.</param>
    ///  <returns>HResult. S_OK on success, E_UNEXPECTED if an exception occurs
    ///  in the wrapped stream, STG_E_INVALIDFLAG if grfStatFlag is not valid or
    ///  STG_E_INVALIDPOINTER if statstg is not a valid pointer.</returns>
    ///  <remarks>
    ///  <para>If grfStatFlag is STATFLAG_NORMAL then the pwcsName field of
    ///  statstg must be freed by the caller using the task allocator.</para>
    ///  <para>In addition to the dwType and pwcsName fields of statstg, this
    ///  implementation adds stream access, modification and creation date
    ///  information when available.</para>
    ///  <para>The value of the pwcsName field, when set, is determined by the
    ///  string returned from the GetStreamNameAsString method.</para>
    ///  <para>Method of IStream interface.</para>
    ///  </remarks>
    function Stat(out statstg: TStatStg; grfStatFlag: Longint): HResult;
      override; stdcall;
  end;

type
  ///  <summary>
  ///  Class that implements a IStream interface on a file.
  ///  </summary>
  ///  <remarks>
  ///  The Stat method uses the file name as the value of pwcsName field of its
  ///  statstg parameter.
  ///  </remarks>
  TPJFileIStream = class(TPJHandleIStreamWrapper, IStream)
  {$IFDEF SUPPORTS_STRICT}strict{$ENDIF}
  private
    ///  <summary>Name of file accessed by this object.</summary>
    fFileName: string;
  {$IFDEF SUPPORTS_STRICT}strict{$ENDIF}
  protected
    ///  <summary>Returns the file name as the name of the stream.
    ///  </summary>
    ///  <remarks>This name is used as the value of the pwcsName field returned
    ///  in the statstg field of the Stat method.</remarks>
    function GetStreamNameAsString: string; override;
  public
    ///  <summary>Object constructor. Opens a stream onto a file that supports
    ///  the IStream interface.</summary>
    ///  <param name="FileName">string [in] Name of file.</param>
    ///  <param name="Mode">Word [in] Bitmask determining how the file is to be
    ///  opened. Valid values are the same as those used in the TFileStream
    ///  constructor.</param>
    constructor Create(const FileName: string; Mode: Word);
  end;


implementation


uses
  // Delphi
  {$IFNDEF RTLNAMESPACES}
  Math, SysUtils,
  {$ELSE}
  System.Math, System.SysUtils,
  {$ENDIF}
  // Library
  PJStreamWrapper;


{ TPJIStreamWrapper }

function TPJIStreamWrapper.Clone(out stm: IStream): HResult;
begin
  Result := E_NOTIMPL;
end;

function TPJIStreamWrapper.Commit(grfCommitFlags: Integer): HResult;
begin
  Result := S_OK;
end;

function TPJIStreamWrapper.CopyTo(stm: IStream; cb: Largeint; out cbRead,
  cbWritten: Largeint): HResult;
var
  BytesRead: Integer;     // number of bytes read in a chunk
  BytesWritten: Integer;  // number of bytes written in a chunk
  BufSize: Integer;       // size of buffer used for copying data
  Buffer: PByte;          // buffer used for copying data
const
  MaxBufSize = 1024 * 1024; // maximum size of copy buffer
begin
  // Assume no bytes anre read / written
  if Assigned(@cbRead) then
    cbRead := 0;
  if Assigned(@cbWritten) then
    cbWritten := 0;
  // Check parameters for validity
  if not Assigned(stm) then
  begin
    Result := STG_E_INVALIDPOINTER;
    Exit;
  end;
  // Do copy
  Result := S_OK;
  try
    BufSize := Min(MaxBufSize, cb);
    GetMem(Buffer, BufSize);
    try
      while cb > 0 do
      begin
        BytesRead := BaseStream.Read(Buffer^, Min(BufSize, cb));
        if BytesRead = 0 then
          // end of stream reached
          Exit;
        if Assigned(@cbRead) then
          Inc(cbRead, BytesRead);
        Result := stm.Write(Buffer, BytesRead, @BytesWritten);
        if Assigned(@cbWritten) then
          Inc(cbWritten, BytesWritten);
        if Succeeded(Result) and (BytesRead <> BytesWritten) then
          // couldn't write all data: probably medium or stream full
          Result := STG_E_MEDIUMFULL;
        if Failed(Result) then
          Exit; // write error
        Dec(cb, BytesRead);
      end;
    finally
      FreeMem(Buffer, BufSize);
    end;
  except
    // exception during copy
    Result := E_UNEXPECTED;
  end;
end;

constructor TPJIStreamWrapper.Create(const Stream: TStream;
  const CloseStream: Boolean = False);
begin
  inherited Create;
  fBaseStream := Stream;
  fCloseStream := CloseStream;
end;

destructor TPJIStreamWrapper.Destroy;
begin
  if fCloseStream then
    fBaseStream.Free;
  inherited Destroy;
end;

function TPJIStreamWrapper.GetStreamName: POleStr;
var
  Name: string;     // name of stream
begin
  Name := GetStreamNameAsString;
  Result := CoTaskMemAlloc(SizeOf(WideChar) * (Length(Name) + 1));
  StringToWideChar(Name, Result, Length(Name) + 1);
end;

function TPJIStreamWrapper.GetStreamNameAsString: string;
begin
  Result := ClassName + '(' + fBaseStream.ClassName + ')';
end;

function TPJIStreamWrapper.LockRegion(libOffset, cb: Largeint;
  dwLockType: Integer): HResult;
begin
  Result := STG_E_INVALIDFUNCTION;
end;

function TPJIStreamWrapper.Read(pv: Pointer; cb: Integer;
  pcbRead: PLongint): HResult;
var
  Read: LongInt;  // number of bytes read
begin
  // Check params
  if Assigned(pv) then
  begin
    try
      // Read the data into the buffer
      Read := fBaseStream.Read(pv^, cb);
      if Assigned(pcbRead) then
        pcbRead^ := Read;
      Result := S_OK
    except
      Result := S_FALSE;
    end;
  end
  else
    // Nil buffer pointer
    Result := STG_E_INVALIDPOINTER;
end;

function TPJIStreamWrapper.Revert: HResult;
begin
  Result := STG_E_REVERTED;
end;

function TPJIStreamWrapper.Seek(dlibMove: Largeint; dwOrigin: Integer;
  out libNewPosition: Largeint): HResult;
var
  {$IFDEF SUPPORTS_TSTREAM64}
  Origin: TSeekOrigin;        // seek origin in terms of TStream
  {$ELSE}
  Origin: Word;               // seek origin in terms of TStream
  {$ENDIF}
  NewPosition: Largeint;      // new file pointer position after seek
  Wrapper: TPJStreamWrapper;  // stream wrapper to perform actual seek
begin
  // Translate origin from IStream constant to TStream constant
  case dwOrigin of
    STREAM_SEEK_SET:
      {$IFDEF SUPPORTS_TSTREAM64}
      Origin := soBeginning;
      {$ELSE}
      Origin := soFromBeginning;
      {$ENDIF}
    STREAM_SEEK_CUR:
      {$IFDEF SUPPORTS_TSTREAM64}
      Origin := soCurrent;
      {$ELSE}
      Origin := soFromCurrent;
      {$ENDIF}
    STREAM_SEEK_END:
      {$IFDEF SUPPORTS_TSTREAM64}
      Origin := soEnd;
      {$ELSE}
      Origin := soFromEnd;
      {$ENDIF}
    else
    begin
      Result := STG_E_INVALIDFUNCTION;
      Exit;
    end
  end;
  try
    // We use a TPJStreamWrapper to perform seek so that it can fix any problems
    // with seek on a TStringStream using STREAM_SEEK_END origin (see comments
    // in PJStreamWrapper unit for details).
    Wrapper := TPJStreamWrapper.Create(fBaseStream);
    try
      // Valid origin: do seek and record new position if it's assigned
      NewPosition := Wrapper.Seek(dlibMove, Origin);
      if Assigned(@libNewPosition) then
        libNewPosition := NewPosition;
      // seek succeeded
      Result := S_OK;
    finally
      Wrapper.Free;
    end;
  except
    // seek failed
    Result := STG_E_INVALIDPOINTER;
  end;
end;

function TPJIStreamWrapper.SetSize(libNewSize: Largeint): HResult;
begin
  try
    // Set the stream size and compare actual new size to requested
    fBaseStream.Size := libNewSize;
    if libNewSize = fBaseStream.Size then
      Result := S_OK
    else
      Result := E_FAIL;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TPJIStreamWrapper.Stat(out statstg: TStatStg;
  grfStatFlag: Integer): HResult;
begin
  // Check parameters for validity
  if Assigned(@statstg) then
  begin
    if (grfStatFlag = STATFLAG_DEFAULT)
      or (grfStatFlag = STATFLAG_NONAME) then
    begin
      // Update TStatStg structure
      try
        FillChar(statstg, SizeOf(TStatStg), 0);
        with statstg do
        begin
          dwType := STGTY_STREAM;
          if grfStatFlag <> STATFLAG_NONAME then
            pwcsName := GetStreamName;
          cbSize := fBaseStream.Size;
        end;
        Result := S_OK;
      except
        Result := E_UNEXPECTED;
      end;
    end
    else
      // Bad flag
      Result := STG_E_INVALIDFLAG;
  end
  else
    // TStatStg pointer is nil
    Result := STG_E_INVALIDPOINTER;
end;

function TPJIStreamWrapper.UnlockRegion(libOffset, cb: Largeint;
  dwLockType: Integer): HResult;
begin
  Result := STG_E_INVALIDFUNCTION;
end;

function TPJIStreamWrapper.Write(pv: Pointer; cb: Integer;
  pcbWritten: PLongint): HResult;
var
  Written: LongInt; // number of bytes written
begin
  // Check parameters
  if Assigned(pv) then
  begin
    try
      // Attempt to write the data from the buffer to the stream
      Written := fBaseStream.Write(pv^, cb);
      if Assigned(pcbWritten) then
        pcbWritten^ := Written;
      Result := S_OK;
    except
      Result := STG_E_CANTSAVE;
    end;
  end
  else
    // Bad buffer: nil pointer specified
    Result := STG_E_INVALIDPOINTER;
end;

{ TPJHandleIStreamWrapper }

constructor TPJHandleIStreamWrapper.Create(const Stream: THandleStream;
  const CloseStream: Boolean);
begin
  inherited Create(Stream, CloseStream);
end;

function TPJHandleIStreamWrapper.Stat(out statstg: TStatStg;
  grfStatFlag: Integer): HResult;
var
  FileInfo: TByHandleFileInformation; // info about file associated with handle
begin
  // Get other stats per ancestor method
  Result := inherited Stat(statstg, grfStatFlag);
  // Get file info and record file date info in stats
  if GetFileInformationByHandle(
    (BaseStream as THandleStream).Handle,
    FileInfo) and Assigned(@statstg) then
  begin
    statstg.mtime := FileInfo.ftLastWriteTime;
    statstg.ctime := FileInfo.ftCreationTime;
    statstg.atime := FileInfo.ftLastAccessTime;
  end;
end;

{ TPJFileIStream }

constructor TPJFileIStream.Create(const FileName: string; Mode: Word);
begin
  // Open stream to file: gets closed automatically when this object freed
  inherited Create(TFileStream.Create(FileName, Mode), True);
  fFileName := FileName;
end;

function TPJFileIStream.GetStreamNameAsString: string;
begin
  Result := fFileName;
end;

end.

