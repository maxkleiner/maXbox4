//PENDING: @abstract()
unit xrtl_io_Stream;

{$INCLUDE xrtl.inc}

interface

uses
  SysUtils, Math,
  xrtl_util_Exception, xrtl_util_CPUUtils, xrtl_util_Array,
  xrtl_io_Exception, xrtl_io_ResourceStrings;

const
{ @abstract(Value returned from @link(TXRTLInputStream.Read) method on end of stream.)
}
  XRTLEndOfStreamValue = -1;

type
  TXRTLMarkData     = class;
  TXRTLInputStream  = class;
  TXRTLOutputStream = class;

{ @abstract(Represents a position for the @link(TXRTLInputStream) which can be
            restored with @link(TXRTLInputStream.RestorePosition) later.)
}
  TXRTLMarkData = class
  private
    FOwner: TXRTLInputStream;
    FNext: TXRTLMarkData;
  public
    constructor Create(const AOwner: TXRTLInputStream; const ANext: TXRTLMarkData = nil);
    destructor Destroy; override;
    property   Owner: TXRTLInputStream read FOwner;
    property   Next: TXRTLMarkData read FNext;
    procedure  CheckOwner(const AOwner: TXRTLInputStream); virtual;
  end;

{ @abstract(This abstract class is the superclass of all classes representing
            an input stream of bytes.)
  Applications that need to define a subclass of @name must always provide
  @link(TXRTLInputStream._ReadBuffer) method.
}
  TXRTLInputStream = class
  private
  protected
{ @abstract(A flag which is set by @link(Close) to mark the stream as closed.)
}
    FClosed: Boolean;
{ @abstract(Skips over and discards Count bytes of data from this input stream.)
  The @name method may, for a variety of reasons, end up skipping over some smaller
  number of bytes, possibly 0. This may result from any of a number of conditions;
  reaching end of file before Count bytes have been skipped is only one possibility.
  The actual number of bytes skipped is returned.
  If Count is negative, no bytes are skipped.
  The default implementation reads and discards data using @link(Read) method.
  @param(Count the number of bytes to be skipped.)
  @returns(the actual number of bytes skipped.)
}
    function   _Skip(const Count: Int64): Int64;
    procedure  DoClose; virtual;
{ @abstract(Reads up to Count bytes of data from the input stream into a Buffer.)
  An attempt is made to read as many as Count bytes,
  but a smaller number may be read, possibly zero.
  The number of bytes actually read is returned as an integer.

  This method blocks until input data is available, end of file is detected,
  or an exception is thrown.

  If Count is zero, then no bytes are read and 0 is returned;
  otherwise, there is an attempt to read at least one byte.
  If no byte is available because the stream is at end of file,
  the value @link(XRTLEndOfStreamValue) is returned;
  otherwise, at least one byte is read and stored into Buffer.

  Applications that need to define a subclass of @classname must always override
  @link(_ReadBuffer) method.
  @param(Buffer the buffer into which the data is read.)
  @param(Count the maximum number of bytes to read.)
  @returns(the total number of bytes read into the buffer,
           or @link(XRTLEndOfStreamValue) if there is no more data because
           the end of the stream has been reached.)
}
    function   _ReadBuffer(var Buffer; const Count: Integer): Integer; virtual;
  public
{ A flag which is set by @link(Close) to mark the stream as closed.
  Reads @link(FClosed).
}
    property   Closed: Boolean read FClosed;
{ @abstract(Closes this input stream using @link(Close).)
}
    procedure  BeforeDestruction; override;
{ @abstract(Closes this input stream and releases any system resources associated
            with this stream.)
  @name calls @link(DoClose) to do actual close then stream is marked as
  closed by setting @link(FClosed) to @true.
}
    procedure  Close;
{ @abstract(Returns the number of bytes that can be read (or skipped over) from
            this input stream without blocking by the next caller of a method
            for this input stream.)
  The next caller might be the same thread or another thread.
  The @name method for class @classname always returns 0.
  This method should be overridden by subclasses.
  @returns(the number of bytes that can be read from this input stream without blocking.)
}
    function   BytesAvailable: Int64; virtual;
{ @abstract(Marks a position for the @classname which can be restored later
            with @link(RestorePosition).)
  @returns(the instance of @link(TXRTLMarkData) representing current position.)
  @raises(EXRTLMarkException if position can't be marked.)
}
    function   MarkPosition: TXRTLMarkData; virtual;
{ @abstract(Restores a position marked with @link(MarkPosition).)
  @param(MarkData the instance of @link(TXRTLMarkData) representing position to be restored.)
  @raises(EXRTLRestoreException is position can't be restored.)
}
    procedure  RestorePosition(const MarkData: TXRTLMarkData); virtual;
{ @abstract(Reads the next byte of data from the input stream.)
  The value byte is returned as an int in the range 0 to 255.
  If no byte is available because the end of the stream has been reached,
  the value @link(XRTLEndOfStreamValue) is returned.
  This method blocks until input data is available,
  the end of the stream is detected, or an exception is thrown.

  A subclass must provide an implementation of this method.
}
    function   Read: Integer;
{ @abstract(Reads up to Count bytes of data from the input stream into a Buffer.)
  An attempt is made to read as many as Count bytes,
  but a smaller number may be read, possibly zero.
  The number of bytes actually read is returned as an integer.

  This method blocks until input data is available, end of file is detected,
  or an exception is thrown.

  If Count is zero, then no bytes are read and 0 is returned;
  otherwise, there is an attempt to read at least one byte.
  If no byte is available because the stream is at end of file,
  the value @link(XRTLEndOfStreamValue) is returned;
  otherwise, at least one byte is read and stored into Buffer.

  @name calls @link(_ReadBuffer) to do actual read.
  @param(Buffer the buffer into which the data is read.)
  @param(Count the maximum number of bytes to read.)
  @returns(the total number of bytes read into the buffer,
           or @link(XRTLEndOfStreamValue) if there is no more data because
           the end of the stream has been reached.)
}
    function   ReadBuffer(var Buffer; const Count: Integer): Integer;
{ @abstract(Reads Count bytes of data from the input stream into a Buffer.)
  An attempt is made to read Count bytes.
  If no byte is available because the stream is at end of file,
  the exception @link(EXRTLEndOfStreamException) is raised.

  @param(Buffer the buffer into which the data is read.)
  @param(Count the maximum number of bytes to read.)
  @raises(EXRTLEndOfStreamException if end of stream reached before Count bytes read.)
}
    procedure  ReadBufferFully(var Buffer; const Count: Integer);
{ @abstract(Skips over and discards Count bytes of data from this input stream.)
  The @name method may, for a variety of reasons, end up skipping over some smaller
  number of bytes, possibly 0. This may result from any of a number of conditions;
  reaching end of file before Count bytes have been skipped is only one possibility.
  The actual number of bytes skipped is returned.
  If Count is negative, no bytes are skipped.
  @name calls @link(_Skip) to do actual read.
  @param(Count the number of bytes to be skipped.)
  @returns(the actual number of bytes skipped.)
}
    function   Skip(const Count: Int64): Int64; virtual;
  end;

{ @abstract(This abstract class is the superclass of all classes representing
            an output stream of bytes.)
  An output stream accepts output bytes and sends them to some sink.
  Applications that need to define a subclass of @name must always override
  @link(TXRTLOutputStream._WriteBuffer) method.
}
  TXRTLOutputStream = class
  private
  protected
{ @abstract(A flag which is set by @link(Close) to mark the stream as closed.)
}
    FClosed: Boolean;
{ @abstract(Closes this output stream and releases any system resources associated
            with this stream.)
  The general contract of close is that it closes the output stream.
  A closed stream cannot perform output operations and cannot be reopened.
  Applications that need to define a subclass of @classname must always override
  @link(@classname.@name) method.
}
    procedure  DoClose; virtual;
{ @abstract(Writes the specified data buffer to this output stream.)
  The general contract for @name is that Count bytes are written to the output stream.
  Applications that need to define a subclass of @classname must always override
  @link(@classname.@name) method.
  @param(Buffer data to write)
  @param(Count length of data to write)
}
    procedure  _WriteBuffer(const Buffer; const Count: Integer); virtual;
  public
{ A flag which is set by @link(Close) to mark the stream as closed.
  Reads @link(FClosed).
}
    property   Closed: Boolean read FClosed;
{ @abstract(Closes this output stream using @link(Close).)
}
    procedure  BeforeDestruction; override;
{ @abstract(Closes this output stream and releases any system resources associated
            with this stream.)
  The general contract of close is that it closes the output stream.
  A closed stream cannot perform output operations and cannot be reopened.
  @name calls @link(DoClose) to do actual close then stream is marked as
  closed by setting @link(FClosed) to @true.
}
    procedure  Close;
{ @abstract(Flushes this output stream and forces any buffered output bytes to be written out.)
  The general contract of @name is that calling it is an indication that,
  if any bytes previously written have been buffered by the implementation
  of the output stream, such bytes should immediately be written to their intended destination.
  The @name method of @classname does nothing.
}
    procedure  Flush; virtual;
{ @abstract(Writes the specified byte to this output stream.)
  The general contract for @name is that one byte is written to the output stream.
  @param(Value the byte)
}
    procedure  Write(const Value: Byte);
{ @abstract(Writes the specified data buffer to this output stream.)
  The general contract for @name is that Count bytes are written to the output stream.
  @name calls @link(_WriteBuffer) to do actual write.
  @param(Buffer data to write)
  @param(Count length of data to write)
}
    procedure  WriteBuffer(const Buffer; const Count: Integer);
  end;

{ @abstract(A TXRTLFilterInputStream contains some other input stream,
            which it uses as its basic source of data, possibly transforming
            the data along the way or providing additional functionality.)
  The class @classname itself simply overrides all methods of @link(TXRTLInputStream)
  with versions that pass all requests to the contained input stream.
  Subclasses of TXRTLFilterInputStream may further override some of these
  methods and may also provide additional methods and fields.
}
  TXRTLFilterInputStream = class(TXRTLInputStream)
  private
  protected
    FCoreStream: TXRTLInputStream;
    FOwnCoreStream: Boolean;
    procedure  DoClose; override;
    function   _ReadBuffer(var Buffer; const Count: Integer): Integer; override;
  public
    constructor Create(const ACoreStream: TXRTLInputStream; AOwnCoreStream: Boolean = True);
    destructor Destroy; override;
    property   CoreStream: TXRTLInputStream read FCoreStream;
    property   OwnCoreStream: Boolean read FOwnCoreStream write FOwnCoreStream;
    function   BytesAvailable: Int64; override;
    function   MarkPosition: TXRTLMarkData; override;
    procedure  RestorePosition(const MarkData: TXRTLMarkData); override;
    function   Skip(const Count: Int64): Int64; override;
  end;

{ @abstract(This class is the superclass of all classes that filter output streams.)
  These streams sit on top of an already existing output stream
  (the underlying output stream) which it uses as its basic sink of data,
  but possibly transforming the data along the way or providing additional functionality.
  The class TXRTLFilterOutputStream itself simply overrides all methods of
  @link(TXRTLOutputStream) with versions that pass all requests to the underlying
  output stream. Subclasses of TXRTLFilterOutputStream may further override
  some of these methods as well as provide additional methods and fields.
}
  TXRTLFilterOutputStream = class(TXRTLOutputStream)
  private
  protected
    FCoreStream: TXRTLOutputStream;
    FOwnCoreStream: Boolean;
    procedure  DoClose; override;
    procedure  _WriteBuffer(const Buffer; const Count: Integer); override;
  public
    constructor Create(const ACoreStream: TXRTLOutputStream; AOwnCoreStream: Boolean = True);
    destructor Destroy; override;
    property   CoreStream: TXRTLOutputStream read FCoreStream;
    property   OwnCoreStream: Boolean read FOwnCoreStream write FOwnCoreStream;
    procedure  Flush; override;
  end;

  TXRTLSequenceInputStream = class(TXRTLInputStream)
  private
    FStreams: TXRTLArray;
    FCurrentStream: TXRTLInputStream;
    FOwnCoreStreams: Boolean;
    procedure  NextStream;
  protected
    procedure  DoClose; override;
    function   _ReadBuffer(var Buffer; const Count: Integer): Integer; override;
  public
    constructor Create(const ACoreStream1, ACoreStream2: TXRTLInputStream;
                       AOwnCoreStreams: Boolean = True); overload;
    constructor Create(const ACoreStreams: array of TXRTLInputStream;
                       AOwnCoreStreams: Boolean = True); overload;
    destructor Destroy; override;
    property   OwnCoreStreams: Boolean read FOwnCoreStreams write FOwnCoreStreams;
    function   BytesAvailable: Int64; override;
    function   Skip(const Count: Int64): Int64; override;
  end;

  TXRTLMultiOutputStream = class(TXRTLOutputStream)
  private
    FStreams: TXRTLArray;
    FOwnCoreStreams: Boolean;
  protected
    procedure  DoClose; override;
    procedure  _WriteBuffer(const Buffer; const Count: Integer); override;
  public
    constructor Create(const ACoreStream1, ACoreStream2: TXRTLOutputStream;
                       AOwnCoreStreams: Boolean = True); overload;
    constructor Create(const ACoreStreams: array of TXRTLOutputStream;
                       AOwnCoreStreams: Boolean = True); overload;
    destructor Destroy; override;
    property   OwnCoreStreams: Boolean read FOwnCoreStreams write FOwnCoreStreams;
  end;

  TXRTLCountInputStream = class(TXRTLFilterInputStream)
  private
    FPosition: Int64;
  protected
    function   _ReadBuffer(var Buffer; const Count: Integer): Integer; override;
  public
    procedure  AfterConstruction; override;
    property   Position: Int64 read FPosition;
    function   MarkPosition: TXRTLMarkData; override;
    procedure  RestorePosition(const MarkData: TXRTLMarkData); override;
  end;

  TXRTLCountOutputStream = class(TXRTLFilterOutputStream)
  private
    FPosition: Int64;
  protected
    procedure  _WriteBuffer(const Buffer; const Count: Integer); override;
  public
    procedure  AfterConstruction; override;
    property   Position: Int64 read FPosition;
  end;

  TXRTLObservableStreamEvent = procedure(Position: Int64; Step: Integer) of object;

  TXRTLObservableInputStream = class(TXRTLCountInputStream)
  private
    FNotificationSize: Integer;
    FNCount: Integer;
    FOnNotify: TXRTLObservableStreamEvent;
    procedure  SetNotificationSize(const Value: Integer);
  protected
    function   _ReadBuffer(var Buffer; const Count: Integer): Integer; override;
  public
    constructor Create(const ACoreStream: TXRTLInputStream; const ANotificationSize: Integer;
                       AOwnCoreStream: Boolean = True);
    procedure  AfterConstruction; override;
    function   MarkPosition: TXRTLMarkData; override;
    procedure  RestorePosition(const MarkData: TXRTLMarkData); override;
    property   NotificationSize: Integer read FNotificationSize write SetNotificationSize;
    property   OnNotify: TXRTLObservableStreamEvent read FOnNotify write FOnNotify;
  end;

  TXRTLObservableOutputStream = class(TXRTLCountOutputStream)
  private
    FNotificationSize: Integer;
    FNCount: Integer;
    FOnNotify: TXRTLObservableStreamEvent;
    procedure  SetNotificationSize(const Value: Integer);
  protected
    procedure  _WriteBuffer(const Buffer; const Count: Integer); override;
  public
    constructor Create(const ACoreStream: TXRTLOutputStream; const ANotificationSize: Integer;
                       AOwnCoreStream: Boolean = True);
    procedure  AfterConstruction; override;
    property   NotificationSize: Integer read FNotificationSize write SetNotificationSize;
    property   OnNotify: TXRTLObservableStreamEvent read FOnNotify write FOnNotify;
  end;

  TXRTLNullInputStream = class(TXRTLInputStream)
  protected
    function   _ReadBuffer(var Buffer; const Count: Integer): Integer; override;
  public
    function   BytesAvailable: Int64; override;
    function   MarkPosition: TXRTLMarkData; override;
    procedure  RestorePosition(const MarkData: TXRTLMarkData); override;
    function   Skip(const Count: Int64): Int64; override;
  end;

  TXRTLNullOutputStream = class(TXRTLOutputStream)
  protected
    procedure  _WriteBuffer(const Buffer; const Count: Integer); override;
  public
    procedure  Flush; override;
  end;

  TXRTLPartialInputStream = class(TXRTLFilterInputStream)
  private
    FLength: Int64;
    FPosition: Int64;
  protected
    function   _ReadBuffer(var Buffer; const Count: Integer): Integer; override;
  public
    constructor Create(const ACoreStream: TXRTLInputStream; AOwnCoreStream: Boolean = False;
                       const ALength: Int64 = High(Int64));
    property   Length: Int64 read FLength;
    property   Position: Int64 read FPosition;
    function   BytesAvailable: Int64; override;
    function   MarkPosition: TXRTLMarkData; override;
    procedure  RestorePosition(const MarkData: TXRTLMarkData); override;
    function   Skip(const Count: Int64): Int64; override;
  end;

type
  TXRTLLineBreakStyle = (lbsCR, lbsLF, lbsCRLF, lbsLFCR);

const
  XRTLDefaultLineBreakStyle = lbsCRLF;

type
  TXRTLPrintStream = class(TXRTLFilterOutputStream)
  private
    FLineBreakStyle: TXRTLLineBreakStyle;
  public
    constructor Create(const ACoreStream: TXRTLOutputStream; AOwnCoreStream: Boolean = True;
                       ALineBreakStyle: TXRTLLineBreakStyle = XRTLDefaultLineBreakStyle);
    property   LineBreakStyle: TXRTLLineBreakStyle read FLineBreakStyle write FLineBreakStyle;
    procedure  Print(const S: string);
    procedure  PrintLn(const S: string = '');
  end;

const
  LineBreak: array[TXRTLLineBreakStyle] of string = (#$0D, #$0A, #$0D#$0A, #$0A#$0D);

implementation

uses
  xrtl_util_Value;

{ TXRTLMarkData }

constructor TXRTLMarkData.Create(const AOwner: TXRTLInputStream; const ANext: TXRTLMarkData = nil);
begin
  inherited Create;
  FOwner:= AOwner;
  FNext:= ANext;
end;

destructor TXRTLMarkData.Destroy;
begin
  FreeAndNil(FNext);
  inherited;
end;

procedure TXRTLMarkData.CheckOwner(const AOwner: TXRTLInputStream);
begin
  if Owner <> AOwner then
    raise EXRTLRestoreException.CreateFmt(SXRTLRestoreExceptionFmt, [ClassName]);
end;

{ TXRTLInputStream }

procedure TXRTLInputStream.BeforeDestruction;
begin
  inherited;
  if not FClosed then
    Close;
end;

function TXRTLInputStream.BytesAvailable: Int64;
begin
  Result:= 0;
end;

procedure TXRTLInputStream.Close;
begin
  if not FClosed then
  begin
    DoClose;
    FClosed:= True;
  end;
end;

procedure TXRTLInputStream.DoClose;
begin
end;

function TXRTLInputStream.MarkPosition: TXRTLMarkData;
begin
  raise EXRTLMarkException.CreateFmt(SXRTLMarkExceptionFmt, [ClassName]);
end;

procedure TXRTLInputStream.RestorePosition(const MarkData: TXRTLMarkData);
begin
  raise EXRTLRestoreException.CreateFmt(SXRTLRestoreExceptionFmt, [ClassName]);
end;

function TXRTLInputStream._ReadBuffer(var Buffer; const Count: Integer): Integer;
begin
  XRTLInvalidOperation(ClassName, '_ReadBuffer', 'Not implemented');
  Result:= XRTLEndOfStreamValue;
end;

function TXRTLInputStream._Skip(const Count: Int64): Int64;
begin
  Result:= 0;
  while Result < Count do
  begin
    if Read = XRTLEndOfStreamValue then
      Break;
    Inc(Result);
  end;
end;

function TXRTLInputStream.Read: Integer;
var
  Value: Byte;
begin
  Result:= _ReadBuffer(Value, SizeOf(Value));
  if Result = SizeOf(Value) then
    Result:= Value;
end;

function TXRTLInputStream.ReadBuffer(var Buffer; const Count: Integer): Integer;
var
  P: Pointer;
  LCount, LResult: Integer;
begin
  LCount:= Count;
  P:= @Buffer;
  Result:= 0;
  repeat
    LResult:= _ReadBuffer(P^, LCount);
    if LResult = XRTLEndOfStreamValue then
    begin
      if Result = 0 then
        Result:= XRTLEndOfStreamValue;
      Break;
    end;
    P:= XRTLPointerAdd(P, LResult);
    Dec(LCount, LResult);
    Inc(Result, LResult);
  until LCount = 0;
end;

procedure TXRTLInputStream.ReadBufferFully(var Buffer; const Count: Integer);
var
  P: Pointer;
  LCount, Result: Integer;
begin
  LCount:= Count;
  P:= @Buffer;
  repeat
    Result:= _ReadBuffer(P^, LCount);
    if Result = XRTLEndOfStreamValue then
      raise EXRTLEndOfStreamException.CreateFmt(SXRTLEndOfStreamException, [ClassName]);
    P:= XRTLPointerAdd(P, Result);
    Dec(LCount, Result);
  until LCount = 0;
end;

function TXRTLInputStream.Skip(const Count: Int64): Int64;
begin
  Result:= _Skip(Count);
end;

{ TXRTLOutputStream }

procedure TXRTLOutputStream.BeforeDestruction;
begin
  inherited;
  Close;
end;

procedure TXRTLOutputStream.Close;
begin
  if not FClosed then
  begin
    DoClose;
    FClosed:= True;
  end;
end;

procedure TXRTLOutputStream.DoClose;
begin
end;

procedure TXRTLOutputStream.Flush;
begin
end;

procedure TXRTLOutputStream._WriteBuffer(const Buffer; const Count: Integer);
begin
  XRTLInvalidOperation(ClassName, '_WriteBuffer', 'Not implemented');
end;

procedure TXRTLOutputStream.Write(const Value: Byte);
begin
  _WriteBuffer(Value, SizeOf(Value));
end;

procedure TXRTLOutputStream.WriteBuffer(const Buffer; const Count: Integer);
begin
  _WriteBuffer(Buffer, Count);
end;

{ TXRTLFilterInputStream }

constructor TXRTLFilterInputStream.Create(const ACoreStream: TXRTLInputStream; AOwnCoreStream: Boolean = True);
begin
  inherited Create;
  FCoreStream:= ACoreStream;
  FOwnCoreStream:= AOwnCoreStream;
end;

destructor TXRTLFilterInputStream.Destroy;
begin
  if FOwnCoreStream then
    FreeAndNil(FCoreStream);
  inherited;
end;

function TXRTLFilterInputStream.BytesAvailable: Int64;
begin
  Result:= FCoreStream.BytesAvailable;
end;

procedure TXRTLFilterInputStream.DoClose;
begin
  inherited;
  if FOwnCoreStream then
    FCoreStream.Close;
end;

function TXRTLFilterInputStream.MarkPosition: TXRTLMarkData;
begin
  Result:= FCoreStream.MarkPosition;
end;

procedure TXRTLFilterInputStream.RestorePosition(const MarkData: TXRTLMarkData);
begin
  FCoreStream.RestorePosition(MarkData);
end;

function TXRTLFilterInputStream.Skip(const Count: Int64): Int64;
begin
  Result:= FCoreStream.Skip(Count);
end;

function TXRTLFilterInputStream._ReadBuffer(var Buffer; const Count: Integer): Integer;
begin
  Result:= FCoreStream.ReadBuffer(Buffer, Count);
end;

{ TXRTLFilterOutputStream }

constructor TXRTLFilterOutputStream.Create(const ACoreStream: TXRTLOutputStream; AOwnCoreStream: Boolean = True);
begin
  inherited Create;
  FCoreStream:= ACoreStream;
  FOwnCoreStream:= AOwnCoreStream;
end;

destructor TXRTLFilterOutputStream.Destroy;
begin
  if FOwnCoreStream then
    FreeAndNil(FCoreStream);
  inherited;
end;

procedure TXRTLFilterOutputStream.DoClose;
begin
  if FOwnCoreStream then
    FCoreStream.Close;
  inherited;
end;

procedure TXRTLFilterOutputStream.Flush;
begin
  FCoreStream.Flush;
  inherited;
end;

procedure TXRTLFilterOutputStream._WriteBuffer(const Buffer; const Count: Integer);
begin
  FCoreStream.WriteBuffer(Buffer, Count);
end;

{ TXRTLSequenceInputStream }

constructor TXRTLSequenceInputStream.Create(const ACoreStream1, ACoreStream2: TXRTLInputStream;
                                            AOwnCoreStreams: Boolean = True);
begin
  Create([ACoreStream1, ACoreStream2], AOwnCoreStreams);
end;

constructor TXRTLSequenceInputStream.Create(const ACoreStreams: array of TXRTLInputStream;
  AOwnCoreStreams: Boolean = True);
var
  I: Integer;
begin
  inherited Create;
  FCurrentStream:= nil;
  FOwnCoreStreams:= AOwnCoreStreams;
  FStreams:= TXRTLArray.Create(Length(ACoreStreams));
  for I:= Low(ACoreStreams) to High(ACoreStreams) do
    FStreams.Add(XRTLValue(ACoreStreams[I]));
  NextStream;
end;

destructor TXRTLSequenceInputStream.Destroy;
begin
  FreeAndNil(FStreams);
  inherited;
end;

function TXRTLSequenceInputStream.BytesAvailable: Int64;
begin
  Result:= 0;
  if Assigned(FCurrentStream) then
    Result:= FCurrentStream.BytesAvailable;
end;

procedure TXRTLSequenceInputStream.DoClose;
begin
  while FStreams.GetSize > 0 do
  begin
    NextStream;
  end;
end;

procedure TXRTLSequenceInputStream.NextStream;
begin
  if Assigned(FCurrentStream) then
  begin
    FCurrentStream.Close;
    if FOwnCoreStreams then
      FreeAndNil(FCurrentStream);
  end;
  if FStreams.GetSize > 0 then
  begin
    FCurrentStream:= XRTLGetAsObject(FStreams.GetValue(0)) as TXRTLInputStream;
    FStreams.Remove(0);
  end
  else
    FCurrentStream:= nil;
end;

function TXRTLSequenceInputStream._ReadBuffer(var Buffer; const Count: Integer): Integer;
begin
  Result:= XRTLEndOfStreamValue;
  if not Assigned(FCurrentStream) then
    Exit;
  Result:= FCurrentStream.ReadBuffer(Buffer, Count);
  if Result < 0 then
  begin
    NextStream;
    Result:= ReadBuffer(Buffer, Count);
  end;
end;

function TXRTLSequenceInputStream.Skip(const Count: Int64): Int64;
begin
  Result:= _Skip(Count);
end;

{ TXRTLMultiOutputStream }

constructor TXRTLMultiOutputStream.Create(const ACoreStream1,
  ACoreStream2: TXRTLOutputStream; AOwnCoreStreams: Boolean = True);
begin
  Create([ACoreStream1, ACoreStream2], AOwnCoreStreams);
end;

constructor TXRTLMultiOutputStream.Create(const ACoreStreams: array of TXRTLOutputStream;
  AOwnCoreStreams: Boolean = True);
var
  I: Integer;
begin
  inherited Create;
  FOwnCoreStreams:= AOwnCoreStreams;
  FStreams:= TXRTLArray.Create(Length(ACoreStreams));
  for I:= Low(ACoreStreams) to High(ACoreStreams) do
    FStreams.Add(XRTLValue(ACoreStreams[I]));
end;

destructor TXRTLMultiOutputStream.Destroy;
begin
  if FOwnCoreStreams then
  begin
    while FStreams.GetSize > 0 do
    begin
      XRTLGetAsObject(FStreams.GetValue(0)).Free;
      FStreams.Remove(0);
    end;
  end;
  FreeAndNil(FStreams);
  inherited;
end;

procedure TXRTLMultiOutputStream._WriteBuffer(const Buffer; const Count: Integer);
var
  I: Integer;
begin
  for I:= 0 to FStreams.GetSize - 1 do
  begin
    (XRTLGetAsObject(FStreams.GetValue(I)) as TXRTLOutputStream)._WriteBuffer(Buffer, Count);
  end;
end;

procedure TXRTLMultiOutputStream.DoClose;
var
  I: Integer;
begin
  if FOwnCoreStreams then
  begin
    for I:= 0 to FStreams.GetSize - 1 do
    begin
      (XRTLGetAsObject(FStreams.GetValue(I)) as TXRTLOutputStream).Close;
    end;
  end;
end;

type
  TXRTLCountInputStreamMarkData = class(TXRTLMarkData)
  public
    Position: Int64;
  end;

{ TXRTLCountInputStream }

procedure TXRTLCountInputStream.AfterConstruction;
begin
  inherited;
  FPosition:= 0;
end;

function TXRTLCountInputStream.MarkPosition: TXRTLMarkData;
var
  MD: TXRTLCountInputStreamMarkData;
begin
  MD:= TXRTLCountInputStreamMarkData.Create(Self, inherited MarkPosition);
  MD.Position:= Position;
  Result:= MD;
end;

procedure TXRTLCountInputStream.RestorePosition(const MarkData: TXRTLMarkData);
var
  MD: TXRTLCountInputStreamMarkData;
begin
  MarkData.CheckOwner(Self);
  inherited RestorePosition(MarkData.Next);
  MD:= MarkData as TXRTLCountInputStreamMarkData;
  FPosition:= MD.Position;
end;

function TXRTLCountInputStream._ReadBuffer(var Buffer; const Count: Integer): Integer;
begin
  Result:= inherited _ReadBuffer(Buffer, Count);
  if Result <> XRTLEndOfStreamValue then
    Inc(FPosition, Result);
end;

{ TXRTLCountOutputStream }

procedure TXRTLCountOutputStream.AfterConstruction;
begin
  inherited;
  FPosition:= 0;
end;

procedure TXRTLCountOutputStream._WriteBuffer(const Buffer; const Count: Integer);
begin
  inherited _WriteBuffer(Buffer, Count);
  Inc(FPosition, Count);
end;

type
  TXRTLObservableInputStreamMarkData = class(TXRTLMarkData)
  public
    NCount: Integer;
  end;

{ TXRTLObservableInputStream }

constructor TXRTLObservableInputStream.Create(const ACoreStream: TXRTLInputStream;
  const ANotificationSize: Integer; AOwnCoreStream: Boolean = True);
begin
  inherited Create(ACoreStream, AOwnCoreStream);
  FOnNotify:= nil;
  NotificationSize:= ANotificationSize;
end;

procedure TXRTLObservableInputStream.AfterConstruction;
begin
  inherited;
  FNCount:= 0;
end;

function TXRTLObservableInputStream.MarkPosition: TXRTLMarkData;
var
  MD: TXRTLObservableInputStreamMarkData;
begin
  MD:= TXRTLObservableInputStreamMarkData.Create(Self, inherited MarkPosition);
  MD.NCount:= FNCount;
  Result:= MD;
end;

procedure TXRTLObservableInputStream.RestorePosition(const MarkData: TXRTLMarkData);
var
  MD: TXRTLObservableInputStreamMarkData;
begin
  MarkData.CheckOwner(Self);
  inherited RestorePosition(MarkData.Next);
  MD:= MarkData as TXRTLObservableInputStreamMarkData;
  FNCount:= MD.NCount;
end;

procedure TXRTLObservableInputStream.SetNotificationSize(const Value: Integer);
begin
  FNotificationSize:= Max(1, Min(Value, 1024 * 1024));
end;

function TXRTLObservableInputStream._ReadBuffer(var Buffer; const Count: Integer): Integer;
var
  LCount, LResult: Integer;
  P: PByteArray;
begin
  Result:= 0;
  P:= @Buffer;
  LCount:= Count;
  while LCount > 0 do
  begin
    LResult:= inherited _ReadBuffer(P^, Min(Count - LCount, FNotificationSize));
    if LResult = XRTLEndOfStreamValue then
    begin
      if Result = 0 then
        Result:= XRTLEndOfStreamValue;
      Break;
    end;
    Inc(FNCount, LResult);
    Inc(Result, LResult);
    if FNCount >= FNotificationSize then
    begin
      FNCount:= FNCount - FNotificationSize;
      if Assigned(FOnNotify) then
        FOnNotify(Position, LResult);
    end;
    P:= XRTLPointerAdd(P, LResult);
    Dec(LCount, LResult);
  end;
end;

{ TXRTLObservableOutputStream }

constructor TXRTLObservableOutputStream.Create(const ACoreStream: TXRTLOutputStream;
  const ANotificationSize: Integer; AOwnCoreStream: Boolean = True);
begin
  inherited Create(ACoreStream, AOwnCoreStream);
  FOnNotify:= nil;
  NotificationSize:= ANotificationSize;
end;

procedure TXRTLObservableOutputStream.AfterConstruction;
begin
  inherited;
  FNCount:= 0;
end;

procedure TXRTLObservableOutputStream.SetNotificationSize(const Value: Integer);
begin
  FNotificationSize:= Max(1, Min(Value, 1024 * 1024));
end;

procedure TXRTLObservableOutputStream._WriteBuffer(const Buffer; const Count: Integer);
var
  LCount, LResult: Integer;
  P: PByteArray;
begin
  P:= @Buffer;
  LCount:= Count;
  while LCount > 0 do
  begin
    LResult:= Min(Count - LCount, FNotificationSize);
    inherited _WriteBuffer(P^, LResult);
    Inc(FNCount, LResult);
    if FNCount >= FNotificationSize then
    begin
      FNCount:= FNCount - FNotificationSize;
      if Assigned(FOnNotify) then
        FOnNotify(Position, LResult);
    end;
    P:= XRTLPointerAdd(P, LResult);
    Dec(LCount, LResult);
  end;
end;

{ TXRTLNullInputStream }

function TXRTLNullInputStream.BytesAvailable: Int64;
begin
  Result:= High(Int64);
end;

function TXRTLNullInputStream.MarkPosition: TXRTLMarkData;
begin
  Result:= nil;
end;

procedure TXRTLNullInputStream.RestorePosition(const MarkData: TXRTLMarkData);
begin
end;

function TXRTLNullInputStream._ReadBuffer(var Buffer; const Count: Integer): Integer;
begin
  FillChar(Buffer, Count, 0);
  Result:= Count;
end;

function TXRTLNullInputStream.Skip(const Count: Int64): Int64;
begin
  Result:= Count;
end;

{ TXRTLNullOutputStream }

procedure TXRTLNullOutputStream.Flush;
begin
end;

procedure TXRTLNullOutputStream._WriteBuffer(const Buffer; const Count: Integer);
begin
end;

type
  TXRTLPartialInputStreamMarkData = class(TXRTLMarkData)
  public
    Length: Int64;
    Position: Int64;
  end;

{ TXRTLPartialInputStream }

constructor TXRTLPartialInputStream.Create(const ACoreStream: TXRTLInputStream;
                                         AOwnCoreStream: Boolean = False;
                                         const ALength: Int64 = High(Int64));
begin
  inherited Create(ACoreStream, AOwnCoreStream);
  FLength:= Min(ALength, CoreStream.BytesAvailable);
  FPosition:= 0;
end;

function TXRTLPartialInputStream.BytesAvailable: Int64;
begin
  Result:= FLength - FPosition;
end;

function TXRTLPartialInputStream.MarkPosition: TXRTLMarkData;
var
  MD: TXRTLPartialInputStreamMarkData;
begin
  MD:= TXRTLPartialInputStreamMarkData.Create(Self, CoreStream.MarkPosition);
  MD.Position:= FPosition;
  MD.Length:= FLength;
  Result:= MD;
end;

procedure TXRTLPartialInputStream.RestorePosition(const MarkData: TXRTLMarkData);
var
  MD: TXRTLPartialInputStreamMarkData;
begin
  MarkData.CheckOwner(Self);
  CoreStream.RestorePosition(MarkData.Next);
  MD:= MarkData as TXRTLPartialInputStreamMarkData;
  FPosition:= MD.Position;
  FLength:= MD.Length;
end;

function TXRTLPartialInputStream._ReadBuffer(var Buffer; const Count: Integer): Integer;
begin
  Result:= XRTLEndOfStreamValue;
  if FPosition < FLength then
  begin
    Result:= CoreStream.ReadBuffer(Buffer, Min(Count, BytesAvailable));
    if Result = XRTLEndOfStreamValue then
    begin
      FLength:= FPosition;
    end
    else
      Inc(FPosition, Result);
  end;
end;

function TXRTLPartialInputStream.Skip(const Count: Int64): Int64;
begin
  Result:= 0;
  while Result < Count do
  begin
    if Read = XRTLEndOfStreamValue then
      Break;
    Inc(Result);
  end;
end;

{ TXRTLPrintStream }

constructor TXRTLPrintStream.Create(const ACoreStream: TXRTLOutputStream;
                                    AOwnCoreStream: Boolean = True;
                                    ALineBreakStyle: TXRTLLineBreakStyle = XRTLDefaultLineBreakStyle);
begin
  inherited Create(ACoreStream, AOwnCoreStream);
  FLineBreakStyle:= ALineBreakStyle;
end;

procedure TXRTLPrintStream.Print(const S: string);
begin
  CoreStream.WriteBuffer(S[1], Length(S));
end;

procedure TXRTLPrintStream.PrintLn(const S: string = '');
begin
  Print(S + LineBreak[FLineBreakStyle]);
end;

end.
