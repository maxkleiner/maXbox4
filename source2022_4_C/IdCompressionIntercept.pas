{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  10107: IdCompressionIntercept.pas 
{
{   Rev 1.4    2004.06.13 9:08:38 AM  czhower
{ Comment cleanup
}
{
    Rev 1.3    6/27/2003 2:41:14 PM  BGooijen
  Fixed bug where last part was not compressed/send
}
{
{   Rev 1.2    11/6/2003 17:31:40  GGrieve
{ fix for server Intercept
}
{
    Rev 1.1    4/3/2003 2:51:20 PM  BGooijen
  Now calls DeinitCompressors on disconnect
}
{
{   Rev 1.0    2002.11.12 10:33:46 PM  czhower
}
unit IdCompressionIntercept;

{  This file implements an Indy intercept component that compresses a data
   stream using the open-source zlib compression library.  In order for this
   file to compile on Windows, the follow .obj files *must* be provided as
   delivered with this file:

   deflate.obj
   inflate.obj
   inftrees.obj
   trees.obj
   adler32.obj
   infblock.obj
   infcodes.obj
   infutil.obj
   inffast.obj

   On Linux, the shared-object file libz.so.1 *must* be available on the
   system.  Most modern Linux distributions include this file.

   Simply set the CompressionLevel property to a value between 1 and 9 to
   enable compressing of the data stream.  A setting of 0(zero) disables
   compression and the component is dormant.  The sender *and* received must
   have compression enabled in order to properly decompress the data stream.
   They do *not* have to use the same CompressionLevel as long as they are
   both set to a value between 1 and 9.

   Original Author: Allen Bauer

   This source file is submitted to the Indy project on behalf of Borland
   Sofware Corporation.  No warranties, express or implied are given with
   this source file.
}
{
When compiling with < Delphi 7 and using the command line compiler you may encounter the following
errors:

IdCompressionIntercept.pas(331) Error: Incompatible types
IdCompressionIntercept.pas(152) Error: Unsatisfied forward or external declaration: '_tr_init'
....
IdCompressionIntercept.pas(234) Error: Unsatisfied forward or external declaration: 'inflateReset'
Indy40.dpk(196) Fatal: Could not compile used unit 'IdCompressionIntercept.pas'

To work around this issue this unit must be compiled separately when using the command line
compiler and build the rest using /M. Do not use /B on the second build as it will recompile this
unit. Using the Full??.BAT files will compile Indy properly.
}
interface

{$I IdCompilerDefines.inc}

uses
  {$IFDEF USEZLIBUNIT}
  ZLib,
  {$ENDIF}
  Classes, IdException, IdTCPClient, IdGlobal, IdTCPConnection, IdIntercept;

type

{$IFNDEF USEZLIBUNIT}

  TAlloc = function (AppData: Pointer; Items, Size: Integer): Pointer;
{$IFDEF MSWINDOWS}
  register;
{$ENDIF}
{$IFDEF LINUX}
  cdecl;
{$ENDIF}
  TFree = procedure (AppData, Block: Pointer);
{$IFDEF MSWINDOWS}
  register;
{$ENDIF}
{$IFDEF LINUX}
  cdecl;
{$ENDIF}

  // Internal structure.  Ignore.
  TZStreamRec = packed record
    next_in: PChar;       // next input byte
    avail_in: Integer;    // number of bytes available at next_in
    total_in: Integer;    // total nb of input bytes read so far

    next_out: PChar;      // next output byte should be put here
    avail_out: Integer;   // remaining free space at next_out
    total_out: Integer;   // total nb of bytes output so far

    msg: PChar;           // last error message, NULL if no error
    internal: Pointer;    // not visible by applications

    zalloc: TAlloc;       // used to allocate the internal state
    zfree: TFree;         // used to free the internal state
    AppData: Pointer;     // private data object passed to zalloc and zfree

    data_type: Integer;   //  best guess about the data type: ascii or binary
    adler: Integer;       // adler32 value of the uncompressed data
    reserved: Integer;    // reserved for future use
  end;

{$ENDIF}
  EIdCompressionException = class(EIdException);
  EIdCompressorInitFailure = class(EIdCompressionException);
  EIdDecompressorInitFailure = class(EIdCompressionException);
  EIdCompressionError = class(EIdCompressionException);
  EIdDecompressionError = class(EIdCompressionException);
  TCompressionLevel = 0..9;

  TIdCompressionIntercept = class(TIdConnectionIntercept)
  protected
    FCompressionLevel: TCompressionLevel;
    FCompressRec: TZStreamRec;
    FDecompressRec: TZStreamRec;
    FRecvBuf: Pointer;
    FRecvCount, FRecvSize: Integer;
    FSendBuf: Pointer;
    FSendCount, FSendSize: Integer;
    procedure SetCompressionLevel(Value: TCompressionLevel);
    procedure InitCompressors;
    procedure DeinitCompressors;
  public
    destructor Destroy; override;
    procedure Disconnect; override;
    procedure Receive(ABuffer: TStream); override;
    procedure Send(ABuffer: TStream); override;
  published
    property CompressionLevel: TCompressionLevel read FCompressionLevel write SetCompressionLevel;
  end;

  TIdServerCompressionIntercept = class(TIdServerIntercept)
  private
    FCompressionLevel: TCompressionLevel;
  public
    procedure Init; override;
    function Accept(AConnection: TComponent): TIdConnectionIntercept; override;
  published
    property CompressionLevel: TCompressionLevel read FCompressionLevel write FCompressionLevel;
  end;


implementation

uses IdResourceStrings, SysUtils;

{$IFNDEF USEZLIBUNIT}
const
  Z_NO_FLUSH      = 0;
  Z_PARTIAL_FLUSH = 1;
  Z_SYNC_FLUSH    = 2;
  Z_FULL_FLUSH    = 3;
  Z_FINISH        = 4;

  Z_OK            = 0;
  Z_STREAM_END    = 1;
  Z_NEED_DICT     = 2;
  Z_ERRNO         = (-1);
  Z_STREAM_ERROR  = (-2);
  Z_DATA_ERROR    = (-3);
  Z_MEM_ERROR     = (-4);
  Z_BUF_ERROR     = (-5);
  Z_VERSION_ERROR = (-6);

  Z_NO_COMPRESSION       =   0;
  Z_BEST_SPEED           =   1;
  Z_BEST_COMPRESSION     =   9;
  Z_DEFAULT_COMPRESSION  = (-1);

  Z_FILTERED            = 1;
  Z_HUFFMAN_ONLY        = 2;
  Z_DEFAULT_STRATEGY    = 0;

  Z_BINARY   = 0;
  Z_ASCII    = 1;
  Z_UNKNOWN  = 2;

  Z_DEFLATED = 8;

  zlib_Version = '1.0.4';  {Do not Localize}
{$IFDEF LINUX}
  zlib = 'libz.so.1';      {Do not Localize}
{$ENDIF}

{$IFDEF MSWINDOWS}
{$L deflate.obj}
{$L inflate.obj}
{$L inftrees.obj}
{$L trees.obj}
{$L adler32.obj}
{$L infblock.obj}
{$L infcodes.obj}
{$L infutil.obj}
{$L inffast.obj}

procedure _tr_init; external;
procedure _tr_tally; external;
procedure _tr_flush_block; external;
procedure _tr_align; external;
procedure _tr_stored_block; external;
procedure adler32; external;
procedure inflate_blocks_new; external;
procedure inflate_blocks; external;
procedure inflate_blocks_reset; external;
procedure inflate_blocks_free; external;
procedure inflate_set_dictionary; external;
procedure inflate_trees_bits; external;
procedure inflate_trees_dynamic; external;
procedure inflate_trees_fixed; external;
procedure inflate_trees_free; external;
procedure inflate_codes_new; external;
procedure inflate_codes; external;
procedure inflate_codes_free; external;
procedure _inflate_mask; external;
procedure inflate_flush; external;
procedure inflate_fast; external;

procedure _memset(P: Pointer; B: Byte; count: Integer); cdecl;
begin
  FillChar(P^, count, B);
end;

procedure _memcpy(dest, source: Pointer; count: Integer); cdecl;
begin
  Move(source^, dest^, count);
end;
{$ENDIF}

// deflate compresses data
function deflateInit_(var strm: TZStreamRec; level: Integer; version: PChar;
  recsize: Integer): Integer;
{$IFDEF MSWINDOWS}
  external;
{$ENDIF}
{$IFDEF LINUX}
  cdecl; external zlib name 'deflateInit_';    {Do not Localize}
{$ENDIF}
function deflate(var strm: TZStreamRec; flush: Integer): Integer;
{$IFDEF MSWINDOWS}
  external;
{$ENDIF}
{$IFDEF LINUX}
  cdecl; external zlib name 'deflate';       {Do not Localize}
{$ENDIF}
function deflateEnd(var strm: TZStreamRec): Integer;
{$IFDEF MSWINDOWS}
  external;
{$ENDIF}
{$IFDEF LINUX}
  cdecl; external zlib name 'deflateEnd';   {Do not Localize}
{$ENDIF}

// inflate decompresses data
function inflateInit_(var strm: TZStreamRec; version: PChar;
  recsize: Integer): Integer;
{$IFDEF MSWINDOWS}
  external;
{$ENDIF}
{$IFDEF LINUX}
  cdecl; external zlib name 'inflateInit_';    {Do not Localize}
{$ENDIF}
function inflate(var strm: TZStreamRec; flush: Integer): Integer;
{$IFDEF MSWINDOWS}
  external;
{$ENDIF}
{$IFDEF LINUX}
  cdecl; external zlib name 'inflate';        {Do not Localize}
{$ENDIF}
function inflateEnd(var strm: TZStreamRec): Integer;
{$IFDEF MSWINDOWS}
  external;
{$ENDIF}
{$IFDEF LINUX}
  cdecl; external zlib name 'inflateEnd';     {Do not Localize}
{$ENDIF}
function inflateReset(var strm: TZStreamRec): Integer;
{$IFDEF MSWINDOWS}
  external;
{$ENDIF}
{$IFDEF LINUX}
  cdecl; external zlib name 'inflateReset';    {Do not Localize}
{$ENDIF}


function zlibAllocMem(AppData: Pointer; Items, Size: Integer): Pointer;
{$IFDEF MSWINDOWS}
  register;
{$ENDIF}
{$IFDEF LINUX}
  cdecl;
{$ENDIF}
begin
  Result := AllocMem(Items * Size);
end;

procedure zlibFreeMem(AppData, Block: Pointer);
{$IFDEF MSWINDOWS}
  register;
{$ENDIF}
{$IFDEF LINUX}
  cdecl;
{$ENDIF}
begin
  FreeMem(Block);
end;

{$ENDIF}

{ TIdCompressionIntercept }

procedure TIdCompressionIntercept.DeinitCompressors;
begin
  if Assigned(FCompressRec.zalloc) then
  begin
    deflateEnd(FCompressRec);
    FillChar(FCompressRec, SizeOf(FCompressRec), 0);
  end;
  if Assigned(FDecompressRec.zalloc) then
  begin
    inflateEnd(FDecompressRec);
    FillChar(FDecompressRec, SizeOf(FDecompressRec), 0);
  end;
end;

destructor TIdCompressionIntercept.Destroy;
begin
  DeinitCompressors;
  FreeMem(FRecvBuf);
  FreeMem(FSendBuf);
  inherited;
end;

procedure TIdCompressionIntercept.Disconnect;
begin
  inherited;
  DeinitCompressors;
end;

procedure TIdCompressionIntercept.InitCompressors;
begin
  if not Assigned(FCompressRec.zalloc) then
  begin
    FCompressRec.zalloc := zlibAllocMem;
    FCompressRec.zfree := zlibFreeMem;
    if deflateInit_(FCompressRec, FCompressionLevel, zlib_Version, SizeOf(FCompressRec)) <> Z_OK then
    begin
      raise EIdCompressorInitFailure.Create(RSZLCompressorInitializeFailure);
    end;
  end;
  if not Assigned(FDecompressRec.zalloc) then
  begin
    FDecompressRec.zalloc := zlibAllocMem;
    FDecompressRec.zfree := zlibFreeMem;
    if inflateInit_(FDecompressRec, zlib_Version, SizeOf(FDecompressRec)) <> Z_OK then
    begin
      raise EIdDecompressorInitFailure.Create(RSZLDecompressorInitializeFailure);
    end;
  end;
end;

procedure TIdCompressionIntercept.Receive(ABuffer: TStream);
var
  Buffer: array[0..2047] of Char;
  nChars, C: Integer;
  StreamEnd: Boolean;
begin
  if FCompressionLevel in [1..9] then
  begin
    InitCompressors;
    StreamEnd := False;
    repeat
      nChars := ABuffer.Read(Buffer, SizeOf(Buffer));
      if nChars = 0 then Break;
      FDecompressRec.next_in := Buffer;
      FDecompressRec.avail_in := nChars;
      FDecompressRec.total_in := 0;
      while FDecompressRec.avail_in > 0 do
      begin
        if FRecvCount = FRecvSize then
        begin
          if FRecvSize = 0 then
            FRecvSize := 2048
          else
            Inc(FRecvSize, 1024);
          ReallocMem(FRecvBuf, FRecvSize);
        end;
        FDecompressRec.next_out := PChar(FRecvBuf) + FRecvCount;
        C := FRecvSize - FRecvCount;
        FDecompressRec.avail_out := C;
        FDecompressRec.total_out := 0;
        case inflate(FDecompressRec, Z_NO_FLUSH) of
          Z_STREAM_END:
            StreamEnd := True;
          Z_STREAM_ERROR,
          Z_DATA_ERROR,
          Z_MEM_ERROR:
            raise EIdDecompressionError.Create(RSZLDecompressionError);
        end;
        Inc(FRecvCount, C - FDecompressRec.avail_out);
      end;
    until StreamEnd;
    ABuffer.Size := 0;
    ABuffer.Write(FRecvBuf^, FRecvCount);
    FRecvCount := 0;
  end;
end;

procedure TIdCompressionIntercept.Send(ABuffer: TStream);
var
  Buffer: array[0..1023] of Char;
begin
  if FCompressionLevel in [1..9] then
  begin
    InitCompressors;
    // Make sure the Send buffer is large enough to hold the input stream data
    if ABuffer.Size > FSendSize then
    begin
      if ABuffer.Size > 2048 then
        FSendSize := ABuffer.Size + (ABuffer.Size + 1023) mod 1024
      else
        FSendSize := 2048;
      ReallocMem(FSendBuf, FSendSize);
    end;
    // Get the data from the input stream and save it off
    FSendCount := ABuffer.Read(FSendBuf^, ABuffer.Size);
    FCompressRec.next_in := FSendBuf;
    FCompressRec.avail_in := FSendCount;
    FCompressRec.avail_out := 0;
    // reset and clear the input stream in preparation for compression
    ABuffer.Size := 0;
    // As long as data is being outputted, keep compressing
    while FCompressRec.avail_out = 0 do
    begin
      FCompressRec.next_out := Buffer;
      FCompressRec.avail_out := SizeOf(Buffer);
      case deflate(FCompressRec, Z_SYNC_FLUSH) of
        Z_STREAM_ERROR,
        Z_DATA_ERROR,
        Z_MEM_ERROR: raise EIdCompressionError.Create(RSZLCompressionError);
      end;
      // Place the compressed data back into the input stream
      ABuffer.Write(Buffer, SizeOf(Buffer) - FCompressRec.avail_out);
    end;
  end;
end;

procedure TIdCompressionIntercept.SetCompressionLevel(Value: TCompressionLevel);
begin
  if Value <> FCompressionLevel then
  begin
    DeinitCompressors;
    if Value < 0 then Value := 0;
    if Value > 9 then Value := 9;
    FCompressionLevel := Value;
  end;
end;

{ TIdServerCompressionIntercept }

function TIdServerCompressionIntercept.Accept(AConnection: TComponent): TIdConnectionIntercept;
begin
  result := TIdCompressionIntercept.create(AConnection);
  (result as TIdCompressionIntercept).FCompressionLevel := FCompressionLevel;
end;

procedure TIdServerCompressionIntercept.Init;
begin
  // nothing
end;

end.

