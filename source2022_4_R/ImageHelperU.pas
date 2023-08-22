(**
	Declarations copied from the "Project JEDI API Header Library"
	http://www.delphi-jedi.org/apilibrary.html
**)

unit ImageHelperU;

{$mode objfpc}{$H+}

interface

uses SysUtils;

function IsLargeAddressAware (const sExeName: TFileName) : Boolean;

implementation

uses Windows;

const
  IMAGE_SIZEOF_SHORT_NAME = 8;
  {$EXTERNALSYM IMAGE_SIZEOF_SHORT_NAME}

type

//
// Section header format.
//

  TImgSecHdrMisc = record
    case Integer of
      0: (PhysicalAddress: DWORD);
      1: (VirtualSize: DWORD);
  end;

  PIMAGE_SECTION_HEADER = ^IMAGE_SECTION_HEADER;
  {$EXTERNALSYM PIMAGE_SECTION_HEADER}
  _IMAGE_SECTION_HEADER = record
    Name: array [0..IMAGE_SIZEOF_SHORT_NAME - 1] of BYTE;
    Misc: TImgSecHdrMisc;
    VirtualAddress: DWORD;
    SizeOfRawData: DWORD;
    PointerToRawData: DWORD;
    PointerToRelocations: DWORD;
    PointerToLinenumbers: DWORD;
    NumberOfRelocations: WORD;
    NumberOfLinenumbers: WORD;
    Characteristics: DWORD;
  end;
  {$EXTERNALSYM _IMAGE_SECTION_HEADER}
  IMAGE_SECTION_HEADER = _IMAGE_SECTION_HEADER;
  {$EXTERNALSYM IMAGE_SECTION_HEADER}
  TImageSectionHeader = IMAGE_SECTION_HEADER;
  PImageSectionHeader = PIMAGE_SECTION_HEADER;

//
// Directory format.
//

const
  IMAGE_NUMBEROF_DIRECTORY_ENTRIES = 16;
  {$EXTERNALSYM IMAGE_NUMBEROF_DIRECTORY_ENTRIES}

  IMAGE_FILE_LARGE_ADDRESS_AWARE = $0020;

type
  PIMAGE_DATA_DIRECTORY = ^IMAGE_DATA_DIRECTORY;
  {$EXTERNALSYM PIMAGE_DATA_DIRECTORY}
  _IMAGE_DATA_DIRECTORY = record
    VirtualAddress: DWORD;
    Size: DWORD;
  end;
  {$EXTERNALSYM _IMAGE_DATA_DIRECTORY}
  IMAGE_DATA_DIRECTORY = _IMAGE_DATA_DIRECTORY;
  {$EXTERNALSYM IMAGE_DATA_DIRECTORY}
  TImageDataDirectory = IMAGE_DATA_DIRECTORY;
  PImageDataDirectory = PIMAGE_DATA_DIRECTORY;

  PIMAGE_FILE_HEADER = ^IMAGE_FILE_HEADER;
  {$EXTERNALSYM PIMAGE_FILE_HEADER}
  _IMAGE_FILE_HEADER = record
    Machine: WORD;
    NumberOfSections: WORD;
    TimeDateStamp: DWORD;
    PointerToSymbolTable: DWORD;
    NumberOfSymbols: DWORD;
    SizeOfOptionalHeader: WORD;
    Characteristics: WORD;
  end;
  {$EXTERNALSYM _IMAGE_FILE_HEADER}
  IMAGE_FILE_HEADER = _IMAGE_FILE_HEADER;
  {$EXTERNALSYM IMAGE_FILE_HEADER}
  TImageFileHeader = IMAGE_FILE_HEADER;
  PImageFileHeader = PIMAGE_FILE_HEADER;

//
// Optional header format.
//

  PIMAGE_OPTIONAL_HEADER32 = ^IMAGE_OPTIONAL_HEADER32;
  {$EXTERNALSYM PIMAGE_OPTIONAL_HEADER32}
  _IMAGE_OPTIONAL_HEADER = record
    //
    // Standard fields.
    //
    Magic: Word;
    MajorLinkerVersion: Byte;
    MinorLinkerVersion: Byte;
    SizeOfCode: DWORD;
    SizeOfInitializedData: DWORD;
    SizeOfUninitializedData: DWORD;
    AddressOfEntryPoint: DWORD;
    BaseOfCode: DWORD;
    BaseOfData: DWORD;
    //
    // NT additional fields.
    //
    ImageBase: DWORD;
    SectionAlignment: DWORD;
    FileAlignment: DWORD;
    MajorOperatingSystemVersion: Word;
    MinorOperatingSystemVersion: Word;
    MajorImageVersion: Word;
    MinorImageVersion: Word;
    MajorSubsystemVersion: Word;
    MinorSubsystemVersion: Word;
    Win32VersionValue: DWORD;
    SizeOfImage: DWORD;
    SizeOfHeaders: DWORD;
    CheckSum: DWORD;
    Subsystem: Word;
    DllCharacteristics: Word;
    SizeOfStackReserve: DWORD;
    SizeOfStackCommit: DWORD;
    SizeOfHeapReserve: DWORD;
    SizeOfHeapCommit: DWORD;
    LoaderFlags: DWORD;
    NumberOfRvaAndSizes: DWORD;
    DataDirectory: array [0..IMAGE_NUMBEROF_DIRECTORY_ENTRIES - 1] of IMAGE_DATA_DIRECTORY;
  end;
  {$EXTERNALSYM _IMAGE_OPTIONAL_HEADER}
  IMAGE_OPTIONAL_HEADER32 = _IMAGE_OPTIONAL_HEADER;
  {$EXTERNALSYM IMAGE_OPTIONAL_HEADER32}
  TImageOptionalHeader32 = IMAGE_OPTIONAL_HEADER32;
  PImageOptionalHeader32 = PIMAGE_OPTIONAL_HEADER32;

  PIMAGE_ROM_OPTIONAL_HEADER = ^IMAGE_ROM_OPTIONAL_HEADER;
  {$EXTERNALSYM PIMAGE_ROM_OPTIONAL_HEADER}
  _IMAGE_ROM_OPTIONAL_HEADER = record
    Magic: Word;
    MajorLinkerVersion: Byte;
    MinorLinkerVersion: Byte;
    SizeOfCode: DWORD;
    SizeOfInitializedData: DWORD;
    SizeOfUninitializedData: DWORD;
    AddressOfEntryPoint: DWORD;
    BaseOfCode: DWORD;
    BaseOfData: DWORD;
    BaseOfBss: DWORD;
    GprMask: DWORD;
    CprMask: array [0..3] of DWORD;
    GpValue: DWORD;
  end;
  {$EXTERNALSYM _IMAGE_ROM_OPTIONAL_HEADER}
  IMAGE_ROM_OPTIONAL_HEADER = _IMAGE_ROM_OPTIONAL_HEADER;
  {$EXTERNALSYM IMAGE_ROM_OPTIONAL_HEADER}
  TImageRomOptionalHeader = IMAGE_ROM_OPTIONAL_HEADER;
  PImageRomOptionalHeader = PIMAGE_ROM_OPTIONAL_HEADER;

  PIMAGE_OPTIONAL_HEADER64 = ^IMAGE_OPTIONAL_HEADER64;
  {$EXTERNALSYM PIMAGE_OPTIONAL_HEADER64}
  _IMAGE_OPTIONAL_HEADER64 = record
    Magic: Word;
    MajorLinkerVersion: Byte;
    MinorLinkerVersion: Byte;
    SizeOfCode: DWORD;
    SizeOfInitializedData: DWORD;
    SizeOfUninitializedData: DWORD;
    AddressOfEntryPoint: DWORD;
    BaseOfCode: DWORD;
    ImageBase: Int64;
    SectionAlignment: DWORD;
    FileAlignment: DWORD;
    MajorOperatingSystemVersion: Word;
    MinorOperatingSystemVersion: Word;
    MajorImageVersion: Word;
    MinorImageVersion: Word;
    MajorSubsystemVersion: Word;
    MinorSubsystemVersion: Word;
    Win32VersionValue: DWORD;
    SizeOfImage: DWORD;
    SizeOfHeaders: DWORD;
    CheckSum: DWORD;
    Subsystem: Word;
    DllCharacteristics: Word;
    SizeOfStackReserve: Int64;
    SizeOfStackCommit: Int64;
    SizeOfHeapReserve: Int64;
    SizeOfHeapCommit: Int64;
    LoaderFlags: DWORD;
    NumberOfRvaAndSizes: DWORD;
    DataDirectory: array [0..IMAGE_NUMBEROF_DIRECTORY_ENTRIES - 1] of IMAGE_DATA_DIRECTORY;
  end;
  {$EXTERNALSYM _IMAGE_OPTIONAL_HEADER64}
  IMAGE_OPTIONAL_HEADER64 = _IMAGE_OPTIONAL_HEADER64;
  {$EXTERNALSYM IMAGE_OPTIONAL_HEADER64}
  TImageOptionalHeader64 = IMAGE_OPTIONAL_HEADER64;
  PImageOptionalHeader64 = PIMAGE_OPTIONAL_HEADER64;

  PIMAGE_NT_HEADERS64 = ^IMAGE_NT_HEADERS64;
  {$EXTERNALSYM PIMAGE_NT_HEADERS64}
  _IMAGE_NT_HEADERS64 = record
    Signature: DWORD;
    FileHeader: IMAGE_FILE_HEADER;
    OptionalHeader: IMAGE_OPTIONAL_HEADER64;
  end;
  {$EXTERNALSYM _IMAGE_NT_HEADERS64}
  IMAGE_NT_HEADERS64 = _IMAGE_NT_HEADERS64;
  {$EXTERNALSYM IMAGE_NT_HEADERS64}
  TImageNtHeaders64 = IMAGE_NT_HEADERS64;
  PImageNtHeaders64 = PIMAGE_NT_HEADERS64;

  PIMAGE_NT_HEADERS32 = ^IMAGE_NT_HEADERS32;
  {$EXTERNALSYM PIMAGE_NT_HEADERS32}
  _IMAGE_NT_HEADERS = record
    Signature: DWORD;
    FileHeader: IMAGE_FILE_HEADER;
    OptionalHeader: IMAGE_OPTIONAL_HEADER32;
  end;
  {$EXTERNALSYM _IMAGE_NT_HEADERS}
  IMAGE_NT_HEADERS32 = _IMAGE_NT_HEADERS;
  {$EXTERNALSYM IMAGE_NT_HEADERS32}
  TImageNtHeaders32 = IMAGE_NT_HEADERS32;
  PImageNtHeaders32 = PIMAGE_NT_HEADERS32;

  PLOADED_IMAGE = ^LOADED_IMAGE;
  {$EXTERNALSYM PLOADED_IMAGE}
  _LOADED_IMAGE = record
    ModuleName: PSTR;
    hFile: THANDLE;
    MappedAddress: PUCHAR;
{$IFDEF CPU64}
    FileHeader: PIMAGE_NT_HEADERS64;
{$ELSE}
    FileHeader: PIMAGE_NT_HEADERS32;
{$ENDIF}
    LastRvaSection: PIMAGE_SECTION_HEADER;
    NumberOfSections: ULONG;
    Sections: PIMAGE_SECTION_HEADER;
    Characteristics: ULONG;
    fSystemImage: ByteBool;
    fDOSImage: ByteBool;
    Links: LIST_ENTRY;
    SizeOfImage: ULONG;
  end;
  {$EXTERNALSYM _LOADED_IMAGE}
  LOADED_IMAGE = _LOADED_IMAGE;
  {$EXTERNALSYM LOADED_IMAGE}
  TLoadedImage = LOADED_IMAGE;
  PLoadedImage = PLOADED_IMAGE;

function ImageLoad (DllName: PSTR; DllPath: PSTR) : PLOADED_IMAGE;
   	stdcall; external 'imagehlp.dll';

function ImageUnload (const LoadedImage: LOADED_IMAGE) : BOOL;
   	stdcall; external 'imagehlp.dll';

(* ---- *)

function IsLargeAddressAware (const sExeName: TFileName) : Boolean;

var
	pLoadedImage : PLOADED_IMAGE;

begin
    pLoadedImage := ImageLoad (PChar (ExtractFileName (sExeName)),
    						   PChar (ExtractFilePath (sExeName)));

    Win32Check (pLoadedImage <> NIL);

    Result := (pLoadedImage^.Characteristics and
    									   IMAGE_FILE_LARGE_ADDRESS_AWARE) <> 0;

    Win32Check (ImageUnload (pLoadedImage^));
end; { IsLargeAddressAware }

(* ---- *)

end.

