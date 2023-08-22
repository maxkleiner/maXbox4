{******************************************************************************}
{ This unit contains:                                                          }
{   TMapStream - a descendant of TStream encapsulating a memory-mapped file,   }
{              with automatic mutexes for read/write access;                   }
{   TTextMap - a descendant of TMapStream adding text input and output         }
{              routines and optional encryption;                               }
{   TRecordMap - a descendant of TMapStream adding i/o routines for record     }
{              files  and customizable file headers. This is an abstract       }
{              class; descendants need to set the record size property in      }
{              their constructors and override the ReadRec and WriteRec        }
{              abstract methods.                                               }
{                                                                              }
{ Freeware by Deborah Pate                                                     }
{ Version 1.14 created on 18/09/99                                             }
{ Please send bug reports, suggestions etc to Debs@djpate.freeserve.co.uk      }
{                                                                              }
{ **************************************************************************** }
unit MapFiles;

interface

uses Windows, Classes, SysUtils;

type
  EMemoryMappedFile = class(Exception);
  EMMEndOfFile = class(EMemoryMappedFile);
  TFileOptions = (foCreateNew, foCreateAlways, foOpenExisting,
                  foOpenAlways, foTruncateExisting);
  TFileType = (ftUnspecified, ftRandomAccess, ftSequentialAccess);

  TMapStream = class(TStream)
   private
     fActive: boolean;
     fFileName: string;          // name of the file that's being mapped
     fFileOptions: TFileOptions; // set to foOpenExisting by default
     fFileType: TFileType;       // set to ftUnspecified by default
     fInMutex: boolean;
     fMapHandle: THandle;        // handle to the map
     fMapName: string;           // name of the map
     fMemory: pointer;           // pointer to the data itself
     fMutexHandle: THandle;      // mutex handle for sharing
     fMutexName: string;         // same as mapname by default
     fPosition: cardinal;
     fReadOnly: boolean;         // false by default
     fResizeOpenWarning: boolean; // true by default
     fSize: cardinal;            // size of file being mapped
     fWasAlreadyOpen: boolean;   // tells you whether the memory map had
                                 // already been created by another process
     procedure CloseMap;
     procedure CreateFileHandle(var Handle: THandle; IgnoreOptions: boolean);
     procedure CreateMap(NewSize: cardinal);
     function CreateMutex: boolean;
     function MinSize: integer; virtual;
     procedure SetActive(Activate: boolean);
     procedure SetFileName(const Name: string);
     procedure SetMapName(const Name: string);
     procedure SetPosition(Pos: cardinal);
     procedure SetSize(NewSize: cardinal); {$IFDEF VER120} reintroduce; {$ENDIF}
   protected
     {$IFOPT D+}
        function AssertValid: boolean; virtual;
     {$ENDIF}
     function EnterCriticalSection: boolean;
     function Flush: boolean;
     procedure LeaveCriticalSection;
     property FileType: TFileType read fFileType write fFileType;
     property Memory: pointer read fMemory;
     property WasAlreadyOpen: boolean read fWasAlreadyOpen;
   public
     constructor Create(const FileName: string);
     destructor Destroy; override;
     function Read(var Buffer; Count: Longint): Longint; override;
     function Seek(Offset: Longint; Origin: Word): Longint; override;
     function Write(const Buffer; Count: Longint): Longint; override;

     property Active: boolean read fActive write SetActive;
     property FileName: string read fFileName write SetFileName;
     property FileOptions: TFileOptions read fFileOptions write fFileOptions;
     property MapName: string read fMapName write SetMapName;
     property MutexName: string read fMutexName write fMutexName;
     property Position: cardinal read fPosition write SetPosition;
     property ReadOnly: boolean read fReadOnly write fReadOnly;
     property ResizeOpenWarning: boolean read fResizeOpenWarning
                                           write fResizeOpenWarning;
     property Size: cardinal read fSize write SetSize;
  end;

  TTextMap = class(TMapStream)
   private
     fAutoGrow: boolean;
     fUseEncryption: boolean;
   protected
     procedure EnDecode(var InString: PChar; Encrypting: boolean); virtual;
     function ReadToken: string;
     procedure SkipSpaces;
   public
     constructor Create(const FileName: string);  // sets flag for sequential access
     function Read(var Buffer; Count: Longint): Longint; override;
     function ReadChar: Char;
     function ReadInteger: LongInt;
     function ReadFloat: Extended;
     function ReadLine: string;
     function Write(const Buffer; Count: Longint): Longint; override;
     procedure WriteStr(const Str: string);
     procedure WriteStrFmt(const Fmt: string; Args: array of const);
     procedure WriteLineFmt(const Fmt: string; Args: array of const);
     procedure WriteLine(Str: string);
     property AutoGrow: boolean read fAutoGrow write fAutoGrow;
     property UseEncryption: boolean read fUseEncryption write fUseEncryption;
  end;

  TRecordMap = class(TMapStream)
   private
     fHeaderSize: cardinal;
     fRecordSize: cardinal;      // descendants must set this in their constructor
   protected
     {$IFOPT D+}
        function AssertValid: boolean; override;
     {$endif}
     function GetCurrentRec: cardinal;
     function GetRecCount: cardinal;
     function MinSize: integer; override;
     function ReadHeader: boolean; virtual;
     procedure ReadRec(var Rec); virtual; abstract;
     procedure SetCurrentRec(RecNo: cardinal);
     procedure SetRecCount(Count: cardinal);
     procedure WriteHeader; virtual;
     procedure WriteRec(const Rec); virtual; abstract;
     property CurrentRec: cardinal read GetCurrentRec write SetCurrentRec;
     property HeaderSize: cardinal read fHeaderSize write fHeaderSize;
     property RecCount: cardinal read GetRecCount write SetRecCount;
     property RecordSize: cardinal read fRecordSize write fRecordSize;
   public
     constructor Create(const FileName: string); // sets flag for random access
     procedure AppendRec(const Rec);
{        Appends one record to the file. Changing the file size incurs         }
{        a considerable overhead, so to add several records set the            }
{        RecCount property to the required number first and then use WriteRec. }
     procedure First;
     procedure Last;
  end;

implementation
{$IFDEF VER120}
resourcestring
{$ELSE}
const
{$ENDIF}
  SCannotResize = 'Memory map %s is open in another process - cannot resize';
  SCreateMapError = 'Couldn''t create map';
  SCreateMapViewError = 'Could not create map view';
  SDefaultMapName = 'Map';
  SEOFError = 'Cannot read beyond end of file';
  SFileOpenError = 'Could not open file %s';
  SMapCloseError = 'Couldn''t close map handle';
  SNameChangeWhileActiveError = 'Cannot change filename while map is active';
  SReadOnly = 'The memory map %s is readonly';
  SResizeAnywayQuery = 'You may lose any information in the existing map. Proceed?';
  SResizeOpenWarning = 'Warning: attempt to resize open memory map';
  SResizeWhileInactiveError = 'Can''t change size while map is not active';

constructor TMapStream.Create(const FileName: string);
begin
  inherited Create;
  fFileOptions := foOpenExisting;
  fFileName := FileName;
  fFileType := ftUnspecified;
  if (FileName <> '') then
     fMapName := ExtractFileName(FileName)
  else fMapName := SDefaultMapName;
  fMutexName := MapName + 'Mtx';
  fReadOnly := False;
  fResizeOpenWarning := True;
end;

destructor TMapStream.Destroy;
begin
  CloseMap;
  inherited Destroy;
end;

{$IFOPT D+}
function TMapStream.AssertValid: boolean;
{ Useful function for debugging.                                               }
begin
   Result := False;
   if (Active) then begin
      if ((fMapHandle = 0) or (fMemory = nil)) then Exit;
      if (Size = 0) then Exit;
   end
   else begin
      if ((fMapHandle <> 0) or (fMemory <> nil)) then Exit;
      if (Size <> 0) then Exit;
   end;
   Result := True;
end;
{$ENDIF}

procedure TMapStream.CloseMap;
{ Closes the map and mutex handles, flushing the data first if necessary.      }
begin
  if not ReadOnly then Flush;
  UnmapViewOfFile(fMemory);
  if not CloseHandle(fMapHandle) then
     EMemoryMappedFile.Create(SMapCloseError);
  fMapHandle := 0;
  CloseHandle(fMutexHandle);
  fMemory := nil;
  fPosition := 0;
  fSize := 0;
end;

procedure TMapStream.CreateFileHandle(var Handle: THandle; IgnoreOptions: boolean);
{ Creates or opens the physical file and determines the access mode.           }
{ Called by the CreateMap method.                                              }
var
  CreationDistribution: integer;
  FileAttributes: integer;
begin
  { The IgnoreOptions flag ensures that we don't recreate the file every time
    we resize it. }
  if not IgnoreOptions then
     case FileOptions of
       foCreateNew:
          CreationDistribution := CREATE_NEW;
       foCreateAlways:
          CreationDistribution := CREATE_ALWAYS;
       foOpenAlways:
          CreationDistribution := OPEN_ALWAYS;
       foTruncateExisting:
          CreationDistribution := TRUNCATE_EXISTING;
       else CreationDistribution := OPEN_EXISTING;
    end
  else CreationDistribution := OPEN_EXISTING;

  case FileType of
    ftRandomAccess: FileAttributes := FILE_ATTRIBUTE_NORMAL or FILE_FLAG_RANDOM_ACCESS;
    ftSequentialAccess: FileAttributes := FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN;
    else FileAttributes := FILE_ATTRIBUTE_NORMAL;
  end;

 { Call CreateFile, and check for success }
  Handle := CreateFile(PChar(fFileName), GENERIC_READ or GENERIC_WRITE,
                       FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
                       CreationDistribution, FileAttributes, 0);
  if (Handle = INVALID_HANDLE_VALUE) then
     raise EMemoryMappedFile.CreateFmt(SFileOpenError, [FileName]);
end;

procedure TMapStream.CreateMap(NewSize: cardinal);
{ Calls CreateFileHandle to open the physical file, opens or creates the file  }
{ mapping, closes the file handle, then calls MapViewOfFile. Sets the map size }
{ based on the file size. If a filename is not specified, the paging file is   }
{ mapped, and the size is determined by the system granularity - unless the    }
{ map was already open, when its size can be determined only after the map     }
{ view is created.                                                             }
{ Called by SetActive and SetSize.                                             }
var
  Access, Protection: integer;
  DiscFileSize: cardinal;
  FileHandle: THandle;
  MemInfo: TMemoryBasicInformation;
  SysInfo: TSystemInfo;
begin
  if ReadOnly then begin
     Access := FILE_MAP_READ;
     Protection := PAGE_READONLY;
  end
  else begin
     Access := FILE_MAP_ALL_ACCESS;
     Protection := PAGE_READWRITE;
  end;

  { Try to open the map. }
  fMapHandle := OpenFileMapping(Access, BOOL(True), PChar(MapName));
  fWasAlreadyOpen := (fMapHandle <> 0);

  if (FileName <> '') then begin

      { Get the file handle and size. }
      CreateFileHandle(FileHandle, NewSize <> 0);
      DiscFileSize := GetFileSize(FileHandle, nil);

      if (NewSize = 0) then begin         // Creating the map the first time:
         if (DiscFileSize = 0) then       // make sure size > 0
            fSize := MinSize
         else fSize := DiscFileSize;
      end

      else begin                          // Trying to resize the map
        if fWasAlreadyOpen then begin     // Map was Open - can't resize
          if fResizeOpenWarning then begin
            MessageBox(0, PChar(Format(SCannotResize, [fMapName])),
                       PChar(SResizeOpenWarning), MB_OK	or MB_ICONEXCLAMATION);

          end;
          fSize := 0;  // fSize will be determined after MapViewOfFile
        end
        else begin                        // OK, can resize map
          if (NewSize < DiscFileSize) then begin
            FileSeek(FileHandle, NewSize, 0);
            Win32Check(SetEndOfFile(FileHandle));
          end;
          fSize := NewSize;
        end;
      end;

  end
  else if not fWasAlreadyOpen then begin

      { No filename - so use the paging file. }
      FileHandle := $FFFFFFFF;
      GetSystemInfo(SysInfo);
      if NewSize = 0 then
         fSize := SysInfo.dwAllocationGranularity
      else fSize := NewSize;

      { Note that at this point fSize can only be 0 if
        the map was open *and* either no filename was specified, or
        ResizeOnException is set to false. }
  end;

  try
     { If the map wasn't open, create it. }
     if not fWasAlreadyOpen then begin
        fMapHandle := CreateFileMapping(FileHandle, nil, Protection,
                                        0, fSize, PChar(MapName));
        if (fMapHandle = 0) then begin
           fSize := 0;
           raise EMemoryMappedFile.Create(SCreateMapError);
        end;
     end;
  finally
     CloseHandle(FileHandle);
  end;

  if not ReadOnly then
     CreateMutex;

  fMemory := MapViewOfFile(fMapHandle, Access, 0, 0, 0);

  if (fMemory <> nil) then begin
      if (Size = 0) then begin

         { Another process has determined the map size, so we need to find it here }
         VirtualQuery(fMemory, MemInfo, sizeof(MemInfo));
         fSize := MemInfo.RegionSize;
      end;
  end
  else begin
     CloseMap;
     raise EMemoryMappedFile.Create(SCreateMapViewError);
  end;

end;

function TMapStream.CreateMutex: boolean;
{ Create a mutex which will be used when writing to the mapfile.               }
{ Called by CreateMap and MapExists, if write access to the map is required.   }
begin
  if (fMutexHandle = 0) then
      fMutexHandle := Windows.CreateMutex(nil, False, PChar(fMutexName));
  if (fMutexHandle = 0) then
      Result := False
  else Result := True;
end;

function TMapStream.EnterCriticalSection: boolean;
{ Grab the mutex to prevent other processes accessing the file while we write  }
{ to it.                                                                       }
{ Called by Write and by Flush.                                                }
begin
  Result := (fMutexHandle <> 0);
  if ((not fInMutex) and Result) then
  begin
    fInMutex := (WaitForSingleObject(fMutexHandle, INFINITE) = WAIT_OBJECT_0);
    Result := fInMutex;
  end;
end;

function TMapStream.Flush: boolean;
{ Flushes the data to disc.                                                    }
{ Called by CloseMap.                                                          }
begin
  if Active then begin
     EnterCriticalSection;
     try
       Result := FlushViewOfFile(Memory, 0);
     finally
       LeaveCriticalSection;
     end;
  end
  else Result := False;
end;

procedure TMapStream.LeaveCriticalSection;
{ Release the mutex now we've finished writing to the file.                    }
begin
  if ((fInMutex) and (fMutexHandle > 0)) then
  begin
    ReleaseMutex(fMutexHandle);
    fInMutex := False;
  end;
end;

function TMapStream.MinSize: integer;
{ Returns the minimum size of the mapping. This is needed when you're mapping  }
{ a new file (0 bytes) because CreateFileMapping doesn't return a valid handle }
{ if the size specified is 0.                                                  }
begin
  Result := 64;  // completely arbitrary value
end;

{$WARNINGS OFF}

function TMapStream.Read(var Buffer; Count: Longint): Longint;
{ Reads Count bytes from the map file into Buffer.                             }
{ *** NB: after using this function, the Position property is set to the end   }
{ *** of the bytes read.                                                       }
begin
  if (Count > 0) then begin
    Result := Size - Position;
    if (Result >= Count) then begin
      Result := Count;
      System.Move(Pointer(integer(Memory) + Position)^, Buffer, Count);
      fPosition := Position + Count;
    end
    else raise EMMEndOfFile.Create(SEOFError);
  end
  else Result := 0;
end;

function TMapStream.Seek(Offset: Longint; Origin: Word): Longint;
{ Set the Position property to Origin + Offset. SeeTStream help.               }
begin
  case Origin of
    soFromBeginning: Position := Offset;
    soFromCurrent: Position := Position + Offset;
    soFromEnd: Position := Size + Offset;
  end;
  Result := Position;
end;

{$WARNINGS ON}

procedure TMapStream.SetActive(Activate: boolean);
{ Opens an existing mapping or creates an new one.                             }
begin
  if (Activate = fActive) then Exit;
  if Activate then begin
     CreateMap(0);
     fActive := True;
  end
  else begin
     CloseMap;
     fActive := False;
  end;
end;

procedure TMapStream.SetFileName(const Name: string);
{ Change the FileName. An exception is raised if the map is active.            }
begin
  if not Active then begin
     fFileName := Name;
  end
  else raise EMemoryMappedFile.Create(SNameChangeWhileActiveError);
end;

procedure TMapStream.SetMapName(const Name: string);
{ Change the MapName. An exception is raised if the map is active.             }
begin
  if not Active then begin
     fMapName := Name;
  end
  else raise EMemoryMappedFile.Create(SNameChangeWhileActiveError);
end;

procedure TMapStream.SetPosition(Pos: cardinal);
{ Set Position, making sure it is no greater than Size.                                  }
begin
  if (Pos <= Size) then
     fPosition := Pos
  else raise EMMEndOfFile.Create(SEOFError);
end;

procedure TMapStream.SetSize(NewSize: cardinal);
{ Change the size of the map file. There seems to be no way to do this without }
{ closing the map and opening it again - a major chore - so it would be better }
{ to avoid making lots of little size changes.                                 }
var
  Pos: cardinal;
begin
  if Active then begin
     if (NewSize <> fSize) then begin
        if ((fFileName = '') and fResizeOpenWarning) then begin
          if (MessageBox(0, PChar(SResizeAnywayQuery), PChar(SResizeOpenWarning),
                         MB_YESNO	or MB_ICONEXCLAMATION))
              <> IDYES then Exit;
        end;
        Pos := Position;
        CloseMap;
        CreateMap(NewSize);
        Position := Pos;
     end;
  end
  else raise EMemoryMappedFile.Create(SResizeWhileInactiveError);
end;

{$WARNINGS OFF}

function TMapStream.Write(const Buffer; Count: Longint): Longint;
{ Writes Count bytes from Buffer to map file, using a mutex. Raises an         }
{ exception if you try to write beyond the end of the file.                    }
{ *** NB: after using this function, the Position property is set to the end   }
{ *** of the bytes written.                                                    }
var
  SetMutex: boolean;
  Pos: integer;
begin
  if ReadOnly then
     raise EMemoryMappedFile.CreateFmt(SReadOnly,[Mapname]);
  if (Count >= 0) then
  begin
     Pos := Position + Count;
     if Pos > 0 then
     begin
        if Pos > Size then
           raise EMMEndOfFile.Create(SEOFError);
        SetMutex := not fInMutex;
        EnterCriticalSection;
        System.Move(Buffer, Pointer(integer(Memory) + Position)^, Count);
        if SetMutex then
           LeaveCriticalSection;
        fPosition := Pos;
        Result := Count;
        Exit;
     end;
  end;
  Result := 0;
end;

{$WARNINGS ON}

{******************************************************************************}
{ TTextMap: a memory mapped text file class.                                   }
{                                                                              }
{******************************************************************************}

constructor TTextMap.Create(const FileName: string);
begin
  inherited Create(FileName);
  fFileType := ftSequentialAccess;
  fUseEncryption := False;
end;

procedure TTextMap.EnDeCode(var InString: PChar; Encrypting: boolean);
{ Very simple encryption and decryption. The Encrypting flag is just to make   }
{ it easier to override this algorithm with a more complicated scheme.         }
{ Called by Read and Write.                                                    }
var
  i: integer;
begin
  for i := 0 to StrLen(InString) - 1 do begin
      InString[i] := Chr(not(Ord(InString[i])));
  end;
end;

function TTextMap.Read(var Buffer; Count: Longint): Longint;
{ Overrides the write method to allow decryption, if required.                 }
var
  Buf: PChar;
begin
  Result := inherited Read(Buffer, Count);
  if UseEncryption then begin
     Buf := StrAlloc(Count + 1);
     try
        System.Move(Buffer, Buf^, Count);
        Buf[Count] := #0;
        EnDeCode(Buf, False);
        System.Move(Buf^, Buffer, Count);
     finally
        StrDispose(Buf);
     end;
  end;
end;

function TTextMap.ReadChar: Char;
{ Read one character from the file.                                            }
begin
  ReadBuffer(Result, 1);
end;


function TTextMap.ReadFloat: Extended;
{ Read a float value from the file.                                            }
begin
  SkipSpaces;
  Result := StrToFloat(ReadToken);
end;

function TTextMap.ReadInteger: LongInt;
{ Read an integer from the file.                                               }
begin
  SkipSpaces;
  Result := StrToInt(ReadToken);
end;

function TTextMap.ReadLine: string;
{ Read a line of text, stripping the line ending characters.                   }
var
  Ch: Char;
begin
  Result := '';

  { Read characters until reaching an end-of-line character }
  while (Read(Ch, 1) = 1) and not (Ch in [#10,#13]) do
    AppendStr(Result, Ch);

  { If the end-of-line is CR, look for a subsequent LF }
  if Ch = #13 then
     if (Read(Ch, 1) = 1) and (Ch <> #10) then
        Dec(fPosition);
end;

function TTextMap.ReadToken: string;
{ Read up to the next non-printing character.                                  }
var
  Ch: Char;
begin
  Result := '';
  while Read(Ch, 1) = 1 do begin
     if (Ch <= ' ') then begin
        Dec(fPosition);
        Break;
     end;
     AppendStr(Result, Ch);
  end;
end;

procedure TTextMap.SkipSpaces;
{ Skip over white space (<= ' ') characters.                                   }
var
  C: Char;
begin
  while Read(C, 1) = 1 do
    if C > ' ' then begin
      { Stop with the first nonspace character. }
      Dec(fPosition);
      Break;
    end;
end;

{$WARNINGS OFF}

function TTextMap.Write(const Buffer; Count: Longint): Longint;
{ Overrides the write method to allow encryption and automatic resizing of     }
{ the map file, if required.                                                   }
var
  Buf: PChar;
begin
  if (AutoGrow and ((Position + Count) > Size)) then
     Size := Position + Count;
  if not UseEncryption then
     Result := inherited Write(Buffer, Count)
  else begin
     Buf := StrAlloc(Count + 1);
     try
        System.Move(Buffer, Buf^, Count);
        Buf[Count] := #0;
        EnDeCode(Buf, True);
        Result := inherited Write(Buf^, Count);
     finally
        StrDispose(Buf);
     end;
  end;
end;

{$WARNINGS ON}

procedure TTextMap.WriteStr(const Str: string);
{ Write a string to the file.                                                  }
begin
  WriteBuffer(Str[1], Length(Str));
end;

procedure TTextMap.WriteStrFmt(const Fmt: string; Args: array of const);
{ Format and write arbitrary arguments.                                        }
begin
  WriteStr(SysUtils.Format(Fmt, Args));
end;

procedure TTextMap.WriteLine(Str: string);
{ Print a line of text, appending a line ending.                               }
begin
  Str := Str + #13 + #10;
  WriteBuffer(Str[1], Length(Str));
end;

procedure TTextMap.WriteLineFmt(const Fmt: string; Args: array of const);
{ Format and write arbitrary arguments, appending a line ending.               }
begin
  WriteLine(SysUtils.Format(Fmt, Args));
end;


{******************************************************************************}
{ TRecordMap: an abstract base class for memory-mapped record files.           }
{ Descendants should:                                                          }
{   a) set the RecordSize and FileHeader details in their constructors;        }
{   b) override the ReadRec and WriteRec abstract methods.                     }
{******************************************************************************}

constructor TRecordMap.Create(const FileName: string);
begin
  inherited Create(FileName);
  fFileType := ftRandomAccess;
end;

procedure TRecordMap.AppendRec(const Rec);
{ Increases the size of the mapping if necessary, then adds Rec to end of the  }
{ file. Changing the file size incurs a considerable overhead each time, so to }
{ add several records set the RecCount property to the required number first   }
{ and then use WriteRec.                                                       }
begin
  Size := Size + RecordSize;
  Last;
  Write(Rec, RecordSize);
end;

{$IFOPT D+}
function TRecordMap.AssertValid: boolean;
{ Useful debugging function.                                                   }
begin
  Result := False;
  if (RecordSize = 0) then Exit;
  Result := inherited AssertValid;
end;
{$ENDIF}

procedure TRecordMap.First;
{ Move to the start of the first record in the file.                           }
begin
  fPosition := HeaderSize;
end;

function TRecordMap.GetCurrentRec: cardinal;
{ Returns the number of the current record (with 0 being the first record in   }
{ the file).                                                                   }
var
  RecPos: cardinal;
begin
  RecPos := (Position - HeaderSize);
  if (RecPos > 0) then
     Result := RecPos div RecordSize
  else Result := 0;
end;

function TRecordMap.GetRecCount: cardinal;
{ Returns the total number of records in the file.                             }
var
  RecPos: cardinal;
begin
  RecPos := (Size - HeaderSize);
  if (RecPos > 0) then
     Result := RecPos div RecordSize
  else Result := 0;
end;

procedure TRecordMap.Last;
{ Sets the Position property to the beginning of the last record in the file.  }
begin
  if (Size > HeaderSize) then
     fPosition := Size - RecordSize
  else fPosition := Size;
end;

function TRecordMap.MinSize: integer;
{ Returns the minimum size of the mapping. This is needed when you're mapping  }
{ a new file (0 bytes) because CreateFileMapping doesn't return a valid handle }
{ for an empty file (as far as I can see).                                     }
begin
  if (HeaderSize <> 0) then
     Result := HeaderSize
  else Result := RecordSize;
end;

function TRecordMap.ReadHeader: boolean;
{ Does nothing. Descendants can override to implement file headers; a boolean  }
{ result enables easy file header checking, e.g.:                              }
{    if not Readheader then NotAValidFile;                                     }
begin
  Result := True;  // just to stop compiler warnings about undefined result
end;

procedure TRecordMap.SetCurrentRec(RecNo: cardinal);
{ Moves the Position property to the start of record number RecNo. Note that   }
{ the first record in the file is number 0.                                    }
begin
  Position := HeaderSize + (RecNo * RecordSize);
  if Position >= Size then
     raise EMemoryMappedFile.Create(SEOFError);
end;

procedure TRecordMap.SetRecCount(Count: cardinal);
{ Sets the size of the mapping. The file will grow to match it. Setting the    }
{ map size has a large overhead, so avoid lots of small allocations.           }
var
  NewSize: cardinal;
begin
  NewSize := HeaderSize + (Count * RecordSize);
  Size := NewSize;
end;

procedure TRecordMap.WriteHeader;
{ Does nothing. Descendants can override to implement file headers - they must }
{ then set the appropriate HeaderSize in their constructors for the First      }
{ procedure to work properly.                                                  }
begin
end;

end.




