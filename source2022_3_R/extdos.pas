{
 ****************************************************************************
    $Id: extdos.pas,v 1.8 2006/10/16 22:21:51 carl Exp $
    Copyright (c) 2004-2006 by Carl Eric Codere

    Extended Operating system routines

    See License.txt for more information on the licensing terms
    for this source code.

 ****************************************************************************
}
{** @author(Carl Eric Codère)
    @abstract(Extended Operating system routines)

    Routines that extend the capabilities of the 
    pascal DOS unit. It supports more information extraction
    from the operating system.
    
    Everything string returned and input is/should be encoded
    in UTF-8 format.
    
    Currently this unit is only supported on the Win32 platform.

}
unit extdos;

interface


uses 
  // tpautils,
   //fpautils,
   //dpautils,
   //vpautils,
   xutils,
   //unicode,
   //dateutil,
//{$IFDEF WIN32}
   windows;
//{$ENDIF}
{//$IFDEF UNIX}
   //posix,
//{$ENDIF}
   //fileio,
   //;

 TYPE
    { The biggest integer type available to this compiler }
    big_integer_t = int64;


const
  {** Return code: No error in operation }  
  EXTDOS_STATUS_OK = 0;
  {** Return code: This routine is unsupported on this operating system. }
  EXTDOS_STATUS_UNSUPPORTED = -1;
  {** Return code: Conversion operation from native date to TDateTime was invalid. }
  EXTDOS_STATUS_DATE_CONVERT_ERROR = -2;
  {** Return code: Filesystem does not support this date }
  EXTDOS_STATUS_DATE_UNSUPPORTED = -3;

type
  {** @abstract(Possible attributes of a resource) }
  tresourceattribute =
   (
     { Any attribute, including no attributes, FOR FIND routines only }
     attr_any,
     {** Resource is read-only globally }
     attr_readonly,
     {** Resource is hidden }
     attr_hidden,
     {** Resource is a system resource }
     attr_system,
     {** Resource is an archive }
     attr_archive,
     {** Resource is a link }
     attr_link,
     {** Resource is a directory }
     attr_directory,
     {** resource is a temporary resource }
     attr_temporary,
     {** resource is encrypted by the operating system }
     attr_encrypted,
     {** resource should not be indexed }
     attr_no_indexing,
     {** resource is a device }
     attr_device,
     {** resource contains extended attributes/reparse point }
     attr_extended,
     {** resource is compressed by the filesystem }
     attr_compressed,
     {** Resource is actually offline }
     attr_offline,
     {** Resource is a sparse file }
     attr_sparse
   );



  {** @abstract(Information on file associations for the shell) }
  TFileAssociation = record
    {** Application name associated with this resource }
    appname: utf8string;
    {** Application executable and parameters to use on this type of resource }
    exename: utf8string;
  end;


  tresourceattributes = set of tresourceattribute;

  {** Statistics for a resource on disk. as returned by @link(getfilestats) }
  TFileStats = record
    {** Name of the resource on disk }
    name: utf8string;
    {** Size of the resource on disk }
    size: big_integer_t;
    {** Owner (User name) of the resource on disk }
    owner: utf8string;
    {** Creation time of the resource }
    ctime: TDateTime;
    {** Last modification time of the resource }
    mtime: TDateTime;
    {** Last access time of the resource }
    atime: TDateTime;
    {** Number of links to resource }
    nlink: integer;
    {** Attributes for this file }
    attributes: tresourceattributes;
    {** association for this file (operating system) }
    association: tfileassociation;
    {** number of parallel streams for this resource }
    streamcount: integer;
    {** number of file accesses since file's creation }
    accesses: integer;
    {** indicates if the times are in UTC format,
        this is always true, unless the filesystem
        does not support this information.
    }
    utc: boolean;
    {** Device where this file resides, this value
        is represented as an hexadecimal null terminated
        string and is operating system dependent. }
    dev: array[0..127] of char;
    {** Unique file serial number, this may change from
        one boot to the next.}
    ino: array[0..127] of char;
    {** Comment associated with this file type (as stored by the operating system) }
    comment: utf8string;
    {** Directory where this file is located }
    dirstr: utf8string;
  end;

{$IFNDEF PASDOC}  
//{$i extdosh.inc}
{$ELSE}
//{$i win32\extdosh.inc}
{$ENDIF}


const
   {** Maximum size of a null-terminated UCS-4 character string }
   MAX_UCS4_CHARS = high(smallint) div (sizeof(ucs4char));
   {** Maximum size of a null-terminated UCS-4 character string }
   MAX_UCS2_CHARS = high(smallint) div (sizeof(ucs2char))-1;

  {** Return status: conversion successful }
  UNICODE_ERR_OK =     0;
  {** Return status: source sequence is illegal/malformed }
  UNICODE_ERR_SOURCEILLEGAL = -1;
  {** Return status: Target space excedeed }
  UNICODE_ERR_LENGTH_EXCEED = -2;
  {** Return status: Some charactrer could not be successfully converted to this format }
  UNICODE_ERR_INCOMPLETE_CONVERSION = -3;
  {** Return status: The character set is not found }
  UNICODE_ERR_NOTFOUND = -4;

type

  {** UTF-8 base data type }
  utf8char = char;
  putf8char = pchar;
  {** UTF-16 base data type }
  utf16char = word;
  {** UCS-4 base data type }
  ucs4char = longword;
  {** UCS-4 null terminated string }
  pucs4char = ^ucs4char;
  {** UCS-2 base data type }
  ucs2char = word;
  pucs2char = ^ucs2char;

  type
  ucs4strarray = array[0..MAX_UCS4_CHARS] of ucs4char;
  pucs4strarray = ^ucs4strarray;

  ucs2strarray = array[0..MAX_UCS2_CHARS] of ucs2char;
  pucs2strarray = ^ucs2strarray;

  type
  {** @abstract(Returned by @link(FindFirstEx) and @link(FindNextEx)) }
  TSearchRecExt = record
    {** File statistics }
    Stats: TFileStats;
    {** Operating system specific data }
    FindHandle  : THandle;
    W32FindData : TWin32FindDataW;
    IncludeAttr : longint;
    SearchAttr: TResourceAttributes;
  end;


  function ucs4strnewucs2(str: pucs2char): pucs4char;
  function ucs4strnewucs4(src: pucs4char): pucs4char;



{************************************************************************}
{                         File management routines                       }
{************************************************************************}

{** @abstract(Returns the file owner account name)

    This routine returns the owner/creator of this resource as a
    login user name. This is usually the user name when the user logged 
    on to the system.  If this routine is not supported, or if there was an error, 
    this  routine returns an empty string.
    
    @param(fname The filename to access (UTF-8 encoded))
    @returns(The account name on success, otherwise an empty string)
}
function GetFileOwner(fname: putf8char): utf8string;

{** @abstract(Returns the last access date and time of a file)

   This returns the last access time of a file in UTC 
   coordinates. Returns 0 if there was no error, otherwise
   returns an operating system (if positive) or module (if negative)  
   specific error code.

   @param(fname The filename to access (UTF-8 encoded))
   @param(atime The file access date in UTC/GMT format)
   @returns(0 on success, otherwise an error code)
}
function GetFileATime(fname: putf8char; var atime: TDateTime): integer;

{** @abstract(Returns the last modification date and time of a file) 

   This returns the last modification time of a file in UTC 
   coordinates. Returns 0 if there was no error, otherwise
   returns an operating system (if positive) or module (if negative)
   specific error code.

   @param(fname The filename to access (UTF-8 encoded))
   @param(atime The file modification date in UTC/GMT format)
   @returns(0 on success, otherwise an error code)
}
function GetFileMTime(fname: putf8char; var mtime: TDateTime): integer;

{** @abstract(Returns the creation date and time of a file) 

   This returns the creation time of a file in UTC 
   coordinates. Returns 0 if there was no error, otherwise
   returns an operating system (if positive) or module (if negative)  
   specific error code.

   @param(fname The filename to access (UTF-8 encoded))
   @param(atime The file creation date in UTC/GMT format)
   @returns(0 on success, otherwise an error code)
}
function GetFileCTime(fname: putf8char; var ctime: TDateTime): integer;

{** @abstract(Returns the size of a file).

   @returns(If error returns big_integer_t(-1), otherwise
     the size of the file is returned.)
}
function GetFilesize(fname: putf8char): big_integer_t;

{** @abstract(Returns the attributes of a file).

   @returns(If error returns big_integer_t(-1), otherwise
     the size of the file is returned.)
}
function GetFileAttributes(fname: putf8char): tresourceattributes;



{** @abstract(Returns information on a file).

   Returns information on a directory or file given
   by the complete file specification to the file.

   @returns(0 if no error, otherwise, an error code)
}
function GetFilestats(fname: putf8char; var stats: TFileStats): integer;


{** 
     @abstract(Verifies the existence of a directory)
     This routine verifies if the directory named can be
     opened or if it actually exists.

     @param DName Name of the directory to check
     @returns FALSE if the directory cannot be opened or if it does not exist.
}
function DirectoryExists(DName : utf8string): Boolean;

{** 
     @abstract(Verifies the existence of a filename)
     This routine verifies if the file named can be
     opened or if it actually exists.

     @param FName Name of the file to check
     @returns FALSE if the file cannot be opened or if it does not exist.
}
Function FileExists(const FName : utf8string): Boolean;


{**
   @abstract(Returns the current active directory)
   
   @param(DirStr The current directory for the process)
   @return(true on success, otherwise false)
}
function GetCurrentDirectory(var DirStr: utf8string): boolean;

{**
   @abstract(Sets the current active directory)
   
   @param(DirStr The current directory to select for the process)
   @return(true on success, otherwise false)
}
function SetCurrentDirectory(const DirStr: utf8string): boolean;


{** @abstract(Change the last access time of a file) 

   Changes the access time of a file. The time
   should be in UTC coordinates. 
   
   If the time is not supported (for example
   a year of 1900 on UNIX system), then an error
   will be reported and no operation will be performed.

   @param(fname The filename to access (UTF-8 encoded))
   @param(atime The new access time)
   @returns(0 on success, otherwise an error code)
}
function SetFileATime(fname: putf8char; newatime: tdatetime): integer;

{** @abstract(Change the modification time of a file) 

   Changes the modification time of a file. The time
   should be in UTC coordinates. 
   
   If the time is not supported (for example
   a year of 1900 on UNIX system), then an error
   will be reported and no operation will be performed.

   @param(fname The filename to access (UTF-8 encoded))
   @param(mtime The new modification time)
   @returns(0 on success, otherwise an error code)
}
function SetFileMTime(fname: putf8char; newmtime: tdatetime): integer;

{** @abstract(Change the creation time of a file) 

   Changes the creation time of a file. The time
   should be in UTC coordinates. 
   
   If the time is not supported (for example
   a year of 1900 on UNIX system), then an error
   will be reported and no operation will be performed.

   @param(fname The filename to access (UTF-8 encoded))
   @param(mtime The new modification time)
   @returns(0 on success, otherwise an error code)
}
function SetFileCTime(fname: putf8char; newctime: tdatetime): integer;

{** @abstract(Searches the specified directory for the first entry
     matching the specified file name and set of attributes.)
     
   @returns(0 on success, otherwise an error code)
}
function FindFirstEx(path: putf8char; attr: tresourceattributes; var SearchRec:TSearchRecExt): integer;

{** @abstract(Returns the next entry that matches the name and
      name specified in a previous call to @link(FindFirstEx).)

   @returns(0 on success, otherwise an error code)
}   
function FindNextEx(var SearchRec: TSearchRecExt): integer;

{** @abstract(Closes the search and frees the resources
      previously allocated by a call to  @link(FindFirstEx).)

   @returns(0 on success, otherwise an error code)
}   
procedure FindCloseEx(var SearchRec: TSearchRecExt);



{************************************************************************}
{                           Account management                           }
{************************************************************************}



{** @abstract(Returns a full name from an account name)

    From a login name, returns the full name of the
    user of this account.
    
    @param(fname The account name)
    @returns(The full name of the user, or an empty string
      upon error or if unknown or unsupported.)
}    
function GetUserFullName(account: utf8string): utf8string;

{** @abstract(Returns the path of the current
        user's application data configuration directory)

   This routine returns the current path where private
   application configuration data should be stored for the 
   logged-on user. If the path does not exist, it is created
   first. 
        
   @returns(The full path to the requested information, or
      an empty string if an error occured).
}
function GetLoginConfigDirectory: utf8string;

{** @abstract(Returns the path of the current
        shared application data configuration directory)
        
   This routine returns the current path where shared
   application configuration data should be stored for the 
   logged-on user. If the path does not exist, it is created
   first.
        
   @returns(The full path to the requested information, or
      an empty string if an error occured).

}
function GetGlobalConfigDirectory: utf8string;


{** @abstract(Returns the path of the user's home directory)

    This routine returns the path of the currently logged in
    user's home directory.
}
function GetLoginHomeDirectory: utf8string;


{** @abstract(Returns the configured language code of the user)
}
{function GetLoginLanguage: string;}

{** @abstract(Returns the configured country code of the user)
}
{function GetLoginCountryCode: string}

{** @abstract(Returns the account name of the currently logged in user)
}
{function GetLogin: utf8string}


implementation

  //uses unicode_x;
  uses fileio, strings, dateutils, sysutils;

{$IFNDEF PASDOC}  
//{$i extdos.inc}
{$ELSE}
//{$i win32\extdos.inc}
{$ENDIF}


{ Convert Windows attributes to our pascal format of attributes }
function WinAttrToExtAttr(dwAttributes: DWORD): TResourceAttributes;
var
  Attributes: TResourceAttributes;
begin
  Attributes:=[];
  if (dwAttributes and FILE_ATTRIBUTE_READONLY)<>0 then
    Include(Attributes, attr_readonly);
  if (dwAttributes and FILE_ATTRIBUTE_HIDDEN)<>0 then
    Include(Attributes, attr_hidden);
  if (dwAttributes and FILE_ATTRIBUTE_SYSTEM)<>0 then
    Include(Attributes, attr_system);
  if (dwAttributes and FILE_ATTRIBUTE_ARCHIVE)<>0 then
    Include(Attributes, attr_archive);
  if (dwAttributes and FILE_ATTRIBUTE_DEVICE)<>0 then
    Include(Attributes, attr_device);
  if (dwAttributes and FILE_ATTRIBUTE_DIRECTORY)<>0 then
    Include(Attributes, attr_directory);
  if (dwAttributes and FILE_ATTRIBUTE_ENCRYPTED)<>0 then
    Include(Attributes, attr_encrypted);
  if (dwAttributes and FILE_ATTRIBUTE_TEMPORARY)<>0 then
    Include(Attributes, attr_temporary);
  if (dwAttributes and FILE_ATTRIBUTE_REPARSE_POINT)<>0 then
    Include(Attributes, attr_extended);
  if (dwAttributes and FILE_ATTRIBUTE_COMPRESSED)<>0 then
    Include(Attributes, attr_compressed);
  if (dwAttributes and FILE_ATTRIBUTE_NOT_CONTENT_INDEXED)<>0 then
    Include(Attributes, attr_no_indexing);
  if (dwAttributes and FILE_ATTRIBUTE_OFFLINE)<>0 then
    Include(Attributes, attr_offline);
  if (dwAttributes and FILE_ATTRIBUTE_SPARSE_FILE)<>0 then
    Include(Attributes, attr_sparse);
  if (dwAttributes = FILE_ATTRIBUTE_NORMAL) then
    Attributes:=[];
  WinAttrToExtAttr:=attributes;
end;

{ Convert our attribute format to Windows attributes }
function ExtAttrToWinAttr(attr: TResourceAttributes): DWORD;
var
 dwAttr: DWORD;
begin
  dwAttr:=0;
  if attr_readonly in attr then
    dwAttr:=dwAttr or FILE_ATTRIBUTE_READONLY;
  if attr_hidden in attr then
    dwAttr:=dwAttr or FILE_ATTRIBUTE_HIDDEN;
  if attr_system in attr then
    dwAttr:=dwAttr or FILE_ATTRIBUTE_SYSTEM;
  if attr_archive in attr then
    dwAttr:=dwAttr or FILE_ATTRIBUTE_ARCHIVE;
  if attr_device in attr then
    dwAttr:=dwAttr or FILE_ATTRIBUTE_DEVICE;
  if attr_directory in attr then
    dwAttr:=dwAttr or FILE_ATTRIBUTE_DIRECTORY;
  if attr_encrypted in attr then
    dwAttr:=dwAttr or FILE_ATTRIBUTE_ENCRYPTED;
  if attr_temporary in attr then
    dwAttr:=dwAttr or FILE_ATTRIBUTE_TEMPORARY;
  if attr_extended in attr then
    dwAttr:=dwAttr or  FILE_ATTRIBUTE_REPARSE_POINT;
  if attr_compressed in attr then
    dwAttr:=dwAttr or  FILE_ATTRIBUTE_COMPRESSED;
  if attr_no_indexing in attr then
    dwAttr:=dwAttr or FILE_ATTRIBUTE_NOT_CONTENT_INDEXED;
  if attr_offline in attr then
    dwAttr:=dwAttr or FILE_ATTRIBUTE_OFFLINE;
  if attr_sparse in attr then
    dwAttr:=dwAttr or FILE_ATTRIBUTE_SPARSE_FILE;
  if attr = [] then
    dwAttr:=FILE_ATTRIBUTE_NORMAL;
  ExtAttrToWinAttr:=dwAttr;
end;


const
 MAX_DEVICE_NAMES = 11;
 DeviceList: array[1..MAX_DEVICE_NAMES] of string[4] =
 ( 
  'CON',
  'AUX',
  'COM1',
  'COM2',
  'COM3',
  'COM4',
  'LPT1',
  'LPT2',
  'LPT3',
  'PRN',
  'NUL'
 );
{ Verifies if this is a special device }
function IsDevice(s: utf8string): boolean;
var
 i: integer;
begin
  IsDevice:=false;
  s:=Upstring(s);
  for i:=1 to MAX_DEVICE_NAMES do
    begin
      if DeviceList[i] =s then
        begin
          IsDevice:=true;
          exit;
        end;
    end;
end;

type
 ASSOCF = DWORD;
   
   ASSOCSTR =  (
    ASSOCSTR_NONE,
    ASSOCSTR_COMMAND,
    ASSOCSTR_EXECUTABLE,
    ASSOCSTR_FRIENDLYDOCNAME,
    ASSOCSTR_FRIENDLYAPPNAME,
    ASSOCSTR_NOOPEN,
    ASSOCSTR_SHELLNEWVALUE,
    ASSOCSTR_DDECOMMAND,
    ASSOCSTR_DDEIFEXEC,
    ASSOCSTR_DDEAPPLICATION,
    ASSOCSTR_DDETOPIC
   );


 type 
 tassocquerystring = function (
     flasgd: ASSOCF;
     str: DWORD; pszAssoc: pucs2char; pszExtra: pucs2char;
     pszOut: pucs2char; var pcchout: DWORD):HRESULT; stdcall;

  type
  pchararray = ^tchararray;
  tchararray = array[#0..#255] of ucs2char;
  taliasinfo = record
    aliasname: string[32];
    table: pchararray;
  end;

  var
  AdvApi32Handle: HMODULE;
  NetApi32Handle: HMODULE;
  ShlWApiHandle:  HMODULE;
  Kernel32Handle: HMODULE;
  UnicowsHandle: HMODULE;


   trailingBytesForUTF8:array[0..255] of byte = (
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
      2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3,4,4,4,4,5,5,5,5
    );


     offsetsFromUTF8: array[0..5] of ucs4char = (
           $00000000, $00003080, $000E2080,
           $03C82080, $FA082080, $82082080
           );


     const
  {* Some fundamental constants *}
  UNI_REPLACEMENT_CHAR = $0000FFFD;
  UNI_MAX_BMP          = $0000FFFF;
  UNI_MAX_UTF16        = $0010FFFF;
  UNI_MAX_UTF32        = $7FFFFFFF;

  { Surrogate marks for UTF-16 encoding }
  UNI_SUR_HIGH_START = $D800;
  UNI_SUR_HIGH_END   = $DBFF;
  UNI_SUR_LOW_START  = $DC00;
  UNI_SUR_LOW_END    = $DFFF;


    halfShift  = 10; {* used for shifting by 10 bits *}

    halfBase = $0010000;
    halfMask = $3FF;


   const
  MAX_ALIAS = 26;

  const
  {** We use the Private User Area to indicate a unmapped code point }
  UNKNOWN_CODEPOINT = $E000;


  { ASCII conversion table }
  asciitoutf32: tchararray =
  (
{00} $0000,{ #  NULL                                                           }
{01} $0001,{ #  START OF HEADING                                               }
{02} $0002,{ #  START OF TEXT                                                  }
{03} $0003,{ #  END OF TEXT                                                    }
{04} $0004,{ #  END OF TRANSMISSION                                            }
{05} $0005,{ #  ENQUIRY                                                        }
{06} $0006,{ #  ACKNOWLEDGE                                                    }
{07} $0007,{ #  BELL                                                           }
{08} $0008,{ #  BACKSPACE                                                      }
{09} $0009,{ #  HORIZONTAL TABULATION                                          }
{0A} $000A,{ #  LINE FEED                                                      }
{0B} $000B,{ #  VERTICAL TABULATION                                            }
{0C} $000C,{ #  FORM FEED                                                      }
{0D} $000D,{ #  CARRIAGE RETURN                                                }
{0E} $000E,{ #  SHIFT OUT                                                      }
{0F} $000F,{ #  SHIFT IN                                                       }
{10} $0010,{ #  DATA LINK ESCAPE                                               }
{11} $0011,{ #  DEVICE CONTROL ONE                                             }
{12} $0012,{ #  DEVICE CONTROL TWO                                             }
{13} $0013,{ #  DEVICE CONTROL THREE                                           }
{14} $0014,{ #  DEVICE CONTROL FOUR                                            }
{15} $0015,{ #  NEGATIVE ACKNOWLEDGE                                           }
{16} $0016,{ #  SYNCHRONOUS IDLE                                               }
{17} $0017,{ #  END OF TRANSMISSION BLOCK                                      }
{18} $0018,{ #  CANCEL                                                         }
{19} $0019,{ #  END OF MEDIUM                                                  }
{1A} $001A,{ #  SUBSTITUTE                                                     }
{1B} $001B,{ #  ESCAPE                                                         }
{1C} $001C,{ #  FILE SEPARATOR                                                 }
{1D} $001D,{ #  GROUP SEPARATOR                                                }
{1E} $001E,{ #  RECORD SEPARATOR                                               }
{1F} $001F,{ #  UNIT SEPARATOR                                                 }
{20} $0020,{ #  SPACE                                                          }
{21} $0021,{ #  EXCLAMATION MARK                                               }
{22} $0022,{ #  QUOTATION MARK                                                 }
{23} $0023,{ #  NUMBER SIGN                                                    }
{24} $0024,{ #  DOLLAR SIGN                                                    }
{25} $0025,{ #  PERCENT SIGN                                                   }
{26} $0026,{ #  AMPERSAND                                                      }
{27} $0027,{ #  APOSTROPHE                                                     }
{28} $0028,{ #  LEFT PARENTHESIS                                               }
{29} $0029,{ #  RIGHT PARENTHESIS                                              }
{2A} $002A,{ #  ASTERISK                                                       }
{2B} $002B,{ #  PLUS SIGN                                                      }
{2C} $002C,{ #  COMMA                                                          }
{2D} $002D,{ #  HYPHEN-MINUS                                                   }
{2E} $002E,{ #  FULL STOP                                                      }
{2F} $002F,{ #  SOLIDUS                                                        }
{30} $0030,{ #  DIGIT ZERO                                                     }
{31} $0031,{ #  DIGIT ONE                                                      }
{32} $0032,{ #  DIGIT TWO                                                      }
{33} $0033,{ #  DIGIT THREE                                                    }
{34} $0034,{ #  DIGIT FOUR                                                     }
{35} $0035,{ #  DIGIT FIVE                                                     }
{36} $0036,{ #  DIGIT SIX                                                      }
{37} $0037,{ #  DIGIT SEVEN                                                    }
{38} $0038,{ #  DIGIT EIGHT                                                    }
{39} $0039,{ #  DIGIT NINE                                                     }
{3A} $003A,{ #  COLON                                                          }
{3B} $003B,{ #  SEMICOLON                                                      }
{3C} $003C,{ #  LESS-THAN SIGN                                                 }
{3D} $003D,{ #  EQUALS SIGN                                                    }
{3E} $003E,{ #  GREATER-THAN SIGN                                              }
{3F} $003F,{ #  QUESTION MARK                                                  }
{40} $0040,{ #  COMMERCIAL AT                                                  }
{41} $0041,{ #  LATIN CAPITAL LETTER A                                         }
{42} $0042,{ #  LATIN CAPITAL LETTER B                                         }
{43} $0043,{ #  LATIN CAPITAL LETTER C                                         }
{44} $0044,{ #  LATIN CAPITAL LETTER D                                         }
{45} $0045,{ #  LATIN CAPITAL LETTER E                                         }
{46} $0046,{ #  LATIN CAPITAL LETTER F                                         }
{47} $0047,{ #  LATIN CAPITAL LETTER G                                         }
{48} $0048,{ #  LATIN CAPITAL LETTER H                                         }
{49} $0049,{ #  LATIN CAPITAL LETTER I                                         }
{4A} $004A,{ #  LATIN CAPITAL LETTER J                                         }
{4B} $004B,{ #  LATIN CAPITAL LETTER K                                         }
{4C} $004C,{ #  LATIN CAPITAL LETTER L                                         }
{4D} $004D,{ #  LATIN CAPITAL LETTER M                                         }
{4E} $004E,{ #  LATIN CAPITAL LETTER N                                         }
{4F} $004F,{ #  LATIN CAPITAL LETTER O                                         }
{50} $0050,{ #  LATIN CAPITAL LETTER P                                         }
{51} $0051,{ #  LATIN CAPITAL LETTER Q                                         }
{52} $0052,{ #  LATIN CAPITAL LETTER R                                         }
{53} $0053,{ #  LATIN CAPITAL LETTER S                                         }
{54} $0054,{ #  LATIN CAPITAL LETTER T                                         }
{55} $0055,{ #  LATIN CAPITAL LETTER U                                         }
{56} $0056,{ #  LATIN CAPITAL LETTER V                                         }
{57} $0057,{ #  LATIN CAPITAL LETTER W                                         }
{58} $0058,{ #  LATIN CAPITAL LETTER X                                         }
{59} $0059,{ #  LATIN CAPITAL LETTER Y                                         }
{5A} $005A,{ #  LATIN CAPITAL LETTER Z                                         }
{5B} $005B,{ #  LEFT SQUARE BRACKET                                            }
{5C} $005C,{ #  REVERSE SOLIDUS                                                }
{5D} $005D,{ #  RIGHT SQUARE BRACKET                                           }
{5E} $005E,{ #  CIRCUMFLEX ACCENT                                              }
{5F} $005F,{ #  LOW LINE                                                       }
{60} $0060,{ #  GRAVE ACCENT                                                   }
{61} $0061,{ #  LATIN SMALL LETTER A                                           }
{62} $0062,{ #  LATIN SMALL LETTER B                                           }
{63} $0063,{ #  LATIN SMALL LETTER C                                           }
{64} $0064,{ #  LATIN SMALL LETTER D                                           }
{65} $0065,{ #  LATIN SMALL LETTER E                                           }
{66} $0066,{ #  LATIN SMALL LETTER F                                           }
{67} $0067,{ #  LATIN SMALL LETTER G                                           }
{68} $0068,{ #  LATIN SMALL LETTER H                                           }
{69} $0069,{ #  LATIN SMALL LETTER I                                           }
{6A} $006A,{ #  LATIN SMALL LETTER J                                           }
{6B} $006B,{ #  LATIN SMALL LETTER K                                           }
{6C} $006C,{ #  LATIN SMALL LETTER L                                           }
{6D} $006D,{ #  LATIN SMALL LETTER M                                           }
{6E} $006E,{ #  LATIN SMALL LETTER N                                           }
{6F} $006F,{ #  LATIN SMALL LETTER O                                           }
{70} $0070,{ #  LATIN SMALL LETTER P                                           }
{71} $0071,{ #  LATIN SMALL LETTER Q                                           }
{72} $0072,{ #  LATIN SMALL LETTER R                                           }
{73} $0073,{ #  LATIN SMALL LETTER S                                           }
{74} $0074,{ #  LATIN SMALL LETTER T                                           }
{75} $0075,{ #  LATIN SMALL LETTER U                                           }
{76} $0076,{ #  LATIN SMALL LETTER V                                           }
{77} $0077,{ #  LATIN SMALL LETTER W                                           }
{78} $0078,{ #  LATIN SMALL LETTER X                                           }
{79} $0079,{ #  LATIN SMALL LETTER Y                                           }
{7A} $007A,{ #  LATIN SMALL LETTER Z                                           }
{7B} $007B,{ #  LEFT CURLY BRACKET                                             }
{7C} $007C,{ #  VERTICAL LINE                                                  }
{7D} $007D,{ #  RIGHT CURLY BRACKET                                            }
{7E} $007E,{ #  TILDE                                                          }
{7F} $007F,{ #  DELETE                                                         }
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT,
     UNKNOWN_CODEPOINT
  );



(*const
  { This list must be in uppercase characters }
  aliaslist: array[1..MAX_ALIAS] of taliasinfo =
  (
    (aliasname: 'ASCII';table: @ASCIItoUTF32),
    (aliasname: 'ISO-8859-1';table: @i8859_1toUTF32),
    (aliasname: 'CP850';table: @cp850toUTF32),
    (aliasname: 'WINDOWS-1252';table: @cp1252toUTF32),
    (aliasname: 'ATARI';table: @AtariSTtoUTF32),
    (aliasname: 'CP367';table: @ASCIItoUTF32),
    (aliasname: 'CP437';table: @cp437toUTF32),
    (aliasname: 'CP819';table: @i8859_1toUTF32),
    (aliasname: 'IBM367';table: @ASCIItoUTF32),
    (aliasname: 'IBM437';table: @cp437toUTF32),
    (aliasname: 'IBM819';    table: @i8859_1toUTF32),
    (aliasname: 'IBM850';table: @cp850toUTF32),
    (aliasname: 'ISO646-US';table: @ASCIItoUTF32),
    (aliasname: 'ISO_8859-1';table: @i8859_1toUTF32),
    (aliasname: 'ISO-8859-2';table: @i8859_2toUTF32),
    (aliasname: 'ISO_8859-2';table: @i8859_2toUTF32),
    (aliasname: 'ISO-8859-5';table: @i8859_5toUTF32),
    (aliasname: 'ISO_8859-5';table: @i8859_5toUTF32),
    (aliasname: 'ISO-8859-16';table: @i8859_16toUTF32),
    (aliasname: 'ISO_8859-16';table: @i8859_16toUTF32),
    (aliasname: 'LATIN1';    table: @i8859_1toUTF32),
    (aliasname: 'LATIN2';    table: @i8859_2toUTF32),
    (aliasname: 'LATIN10';   table: @i8859_16toUTF32),
    (aliasname: 'MACINTOSH';table: @RomantoUTF32),
    (aliasname: 'MACROMAN';table: @RomantoUTF32),
    (aliasname: 'US-ASCII';table: @ASCIItoUTF32)
  );

  //*)


  function utf8_sizeencoding(c: utf8char): integer;
  begin
    utf8_sizeencoding:= trailingBytesForUTF8[ord(c)]+1;
  end;

  function ucs4strnewstr(str: string; srctype: string): pucs4char;
  var
   i: integer;
   dest: pucs4strarray;
   destpchar: pucs4char;
   count: integer;
   Outindex,totalsize: integer;
   CurrentIndex: integer;
   ch: ucs4char;
   ExtraBytesToRead: integer;
   p:pchararray;
   l: longint;
   strlength: integer;
   idx: integer;
  begin
    str:=removenulls(str);
    ucs4strnewstr:=nil;
    srctype:=upstring(srctype);
    dest:=nil;
    p:=nil;
    { Check if we have an empty string }
    if length(str) = 0 then
      begin
        { Just set a size for the null character }
        Getmem(dest,sizeof(ucs4char));
        dest^[0]:=0;
        ucs4strnewstr:=pucs4char(dest);
        exit;
      end;
    { Special case: UTF-8 encoding }
    if srctype = 'UTF-8' then
      begin
        { Calculate the length to store the decoded length }
        i:=1;
        totalsize:=0;
        strlength:=length(str);
        while (i <= strlength) do
          begin
            count:=utf8_sizeencoding(str[i]);
            { increment the pointer accordingly }
            inc(i,count);
            inc(totalsize);
          end;
        Getmem(destpchar,totalsize*sizeof(ucs4char)+sizeof(ucs4char));
        dest:=pucs4strarray(destpchar);
        i:=1;
        OutIndex := 0;
        while (i <= strlength) do
          begin
            ch := 0;
            extrabytestoread:= trailingBytesForUTF8[ord(str[i])];
{            if not isLegalUTF8(str, extraBytesToRead+1) then
              begin
                exit;
              end;}
            for idx:=ExtraBytesToRead downto 1 do
              begin
                ch:=ch + ucs4char(str[i]);
                inc(i);
                ch:=ch shl 6;
              end;
            ch:=ch + ucs4char(str[i]);
            inc(i);
            ch := ch - offsetsFromUTF8[extraBytesToRead];
            if (ch <= UNI_MAX_UTF32) then
              begin
                dest^[OutIndex] := ch;
                inc(OutIndex);
              end
            else
              begin
                dest^[OutIndex] := UNI_REPLACEMENT_CHAR;
                inc(OutIndex);
              end;
          end;
        { add null character }
        dest^[outindex]:=0;
        ucs4strnewstr:=pucs4char(dest);
      end
    else
      begin
        dest:=pucs4strarray(destpchar);
        { Search the alias type }
        for i:=1 to MAX_ALIAS do
          begin
           // if aliaslist[i].aliasname = srctype then
              begin
              //  p:=aliaslist[i].table;
                break;
              end;
          end;
        if not assigned(p) then
            exit;
        { Count the number of characters to allocate }
        totalsize:=0;
        for i:=0 to length(str)-1 do
          begin
            l:=p^[str[i+1]];
            { invalid character }
            if l = UNKNOWN_CODEPOINT then
              continue
            else
              inc(totalsize);
          end;
        { The size to allocate is the same to allocate }
        Getmem(dest,totalsize*sizeof(ucs4char)+sizeof(ucs4char));
        CurrentIndex:=0;
        { Now actually copy the data }
        for i:=0 to length(str)-1 do
          begin
            l:=p^[str[i+1]];
            { invalid character }
            if l = UNKNOWN_CODEPOINT then
              continue
            else
              ch:=ucs4char(l);
            dest^[currentindex]:=ucs4char(ch);
            inc(currentindex);
          end;
        { add null character }
        dest^[currentindex]:=0;
        ucs4strnewstr:=pucs4char(dest);
      end;
  end;


   function ucs4strlen(str: pucs4char): integer;
  var
   counter : Longint;
   stringarray: pucs4strarray;
 Begin
   ucs4strlen:=0;
   if not assigned(str) then
     exit;
   stringarray := pucs4strarray(str);
   counter := 0;
   while stringarray^[counter] <> 0 do
     Inc(counter);
   ucs4strlen := counter;
 end;

  function ucs4strnewucs4(src: pucs4char): pucs4char;
  var
   lengthtoalloc: integer;
   dst: pucs4char;
  begin
    ucs4strnewucs4:=nil;
    if not assigned(src) then
      exit;
    lengthtoalloc:=ucs4strlen(src)*sizeof(ucs4char)+sizeof(ucs4char);
    { also copy the null character }
    Getmem(dst,lengthtoalloc);
    move(src^,dst^,lengthtoalloc);
    ucs4strnewucs4:=dst;
  end;

  function ucs2strlen(str: pucs2char): integer;
  var
   counter : Longint;
   stringarray: pucs2strarray;
 Begin
   ucs2strlen:=0;
   if not assigned(str) then
     exit;
   stringarray := pucs2strarray(str);
   counter := 0;
   while stringarray^[counter] <> 0 do
     Inc(counter);
   ucs2strlen := counter;
 end;


  function ucs2strnew(src: pucs4char): pucs2char;
  var
   ch: ucs4char;
   i: integer;
   StartIndex, EndIndex: integer;
   srcarray: pucs4strarray;
   sizetoalloc: integer;
   buffer: pucs2char;
   dst: pucs2strarray;
  begin
    ucs2strnew := nil;
    if not assigned(src) then
      exit;
    srcarray:=pointer(src);
    sizetoalloc := ucs4strlen(src)*sizeof(ucs2char)+sizeof(ucs2char);
    { Check if only one character is passed as src, in that case
      this is not an UTF string, but a simple character (in other
      words, there is not a length byte.
    }
    StartIndex:=0;
    EndIndex:=ucs4strlen(src)-1;
    Getmem(buffer,sizetoalloc);
{    fillchar(buffer^,sizetoalloc,#0);}
    dst:=pucs2strarray(buffer);
    dst^[0]:=0;

    if EndIndex >= 0 then
      begin
          for i:=StartIndex to EndIndex do
          begin
              ch:=srcarray^[i];
              { this character encoding cannot be represented }
              if ch > UNI_MAX_BMP then
                 begin
                   Freemem(buffer, sizetoalloc);
                   exit;
                 end;
              dst^[i]:=ucs2char(ch and UNI_MAX_BMP);
          end;
      end;
      dst^[EndIndex+1]:=0;
      ucs2strnew:=pucs2char(buffer);
  end;

  function ucs2strdispose(str: pucs2char): pucs2char;
  begin
    ucs2strdispose := nil;
    if not assigned(str) then
      exit;
    Freemem(str,ucs2strlen(str)*sizeof(ucs2char)+sizeof(ucs2char));
    str:=nil;
  end;


   function ucs4strdispose(str: pucs4char): pucs4char;
 begin
    ucs4strdispose := nil;
    if not assigned(str) then
      exit;
    { don't forget to free the null character }
    Freemem(str,ucs4strlen(str)*sizeof(ucs4char)+sizeof(ucs4char));
    str:=nil;
 end;

 const
 ASSOCF_INIT_NOREMAPCLSID = $00000001;
    ASSOCF_INIT_BYEXENAME = $00000002;
    ASSOCF_OPEN_BYEXENAME = $00000002;
    ASSOCF_INIT_DEFAULTTOSTAR = $00000004;
    ASSOCF_INIT_DEFAULTTOFOLDER = $00000008;
    ASSOCF_NOUSERSETTINGS = $00000010;
    ASSOCF_NOTRUNCATE = $00000020;
    ASSOCF_VERIFY = $00000040;
    ASSOCF_REMAPRUNDLL = $00000080;
    ASSOCF_NOFIXUPS = $00000100;
    ASSOCF_IGNOREBASECLASS = $00000200;

    FILE_READ_ATTRIBUTES = $080;

 function ucs4strnewucs2(str: pucs2char): pucs4char;
 var
  namelength: integer;
  FinalName: pucs4char;
  p1: pucs4strarray;
  p2: pucs2strarray;
  i: integer;
 begin
   ucs4strnewucs2:=nil;
   if not assigned(str) then
     exit;
   namelength:=ucs2strlen(str);
   Getmem(FinalName,(namelength+1)*sizeof(ucs4char));
   p1:=pucs4strarray(finalname);
   p2:=pucs2strarray(str);
   { Convert the value to an UCS-4 string }
   for i:=0 to (namelength-1) do
   Begin
     p1^[i]:=ucs4char(p2^[i]);
   end;
   p1^[namelength]:=0;
   ucs4strnewucs2:=FinalName;
 end;


  procedure utf8_setlength(var s: utf8string; l: integer);
  begin
    setlength(s,l);
  end;

  procedure utf16_setlength(var s: array of utf16char; l: integer);
  begin
   s[0]:=utf16char(l);
  end;


  const firstByteMark: array[0..6] of utf8char =
 (
   #$00, #$00, #$C0, #$E0, #$F0, #$F8, #$FC
 );

  const
    byteMask: ucs4char = $BF;
    byteMark: ucs4char = $80;


 function ucs4strpastoutf8(str: pucs4char): utf8string;
  var
   i: integer;
   ch: ucs4char;
   bytesToWrite: integer;
   OutStringLength : integer;
   OutIndex : integer;
   Currentindex: integer;
   StartIndex: integer;
   EndIndex: integer;
   outstr: utf8string;
   inbuf: pucs4strarray;
   idx: integer;
  begin
    OutIndex := 1;
    OutStringLength := 0;
    StartIndex:=0;
    ucs4strpastoutf8:='';
    if not assigned(str) then
      exit;
    EndIndex:=ucs4strlen(str)-1;
    inbuf:=pucs4strarray(str);
    { Assume a greater length than possible, this is here
      for ansistring support.}
    utf8_setlength(outstr,(endindex+1)*sizeof(ucs4char));

    for i:=StartIndex to EndIndex do
     begin
       ch:=inbuf^[i];

       if (ch > UNI_MAX_UTF16) then
       begin
         exit;
       end;

       if ((ch >= UNI_SUR_HIGH_START) and (ch <= UNI_SUR_LOW_END)) then
       begin
         exit;
       end;

      if (ch < ucs4char($80)) then
        bytesToWrite:=1
      else
      if (ch < ucs4char($800)) then
        bytesToWrite:=2
      else
      if (ch < ucs4char($10000)) then
        bytesToWrite:=3
      else
      if (ch < ucs4char($200000)) then
        bytesToWrite:=4
      else
        begin
          ch:=UNI_REPLACEMENT_CHAR;
          bytesToWrite:=2;
        end;
      Inc(outindex,BytesToWrite);
{$IFNDEF ANSISTRINGS}
      //if Outindex > High(utf8string) then
        begin
          ucs4strpastoutf8:=outstr;
          exit;
        end;
{$ENDIF}
      CurrentIndex := BytesToWrite-1;
      for idx:=CurrentIndex downto 1 do
         begin
           dec(OutIndex);
           outstr[outindex] := utf8char((ch or byteMark) and ByteMask);
           ch:=ch shr 6;
         end;
      dec(OutIndex);
      outstr[outindex] := utf8char((byte(ch) or byte(FirstbyteMark[BytesToWrite])));
      inc(OutStringLength,BytesToWrite);
      Inc(OutIndex,BytesToWrite);
    end;
      utf8_setlength(outstr,OutStringLength);
      ucs4strpastoutf8:=outstr;
  end;



procedure GetShellAssociationInfo(const ext: utf8string; var assoc: TFileAssociation;
  var comment: utf8string);
var
 p: pointer;
 passocquerystring: tassocquerystring;
 FinalName: pucs2char;
 UCS4FinalName: pucs4char;
 count: DWORD;
 pucs4: pucs4char;
 pucs2: pucs2char;
 resulth: HRESULT;
begin  
   fillchar(assoc,sizeof(assoc),#0);
   comment:='';
   p:=(GetProcAddress(ShlwApiHandle,'AssocQueryStringW'));
   PAssocQueryString:=tassocquerystring(p);
   if assigned(p) then
     begin
      count:=MAX_PATH;
      Getmem(FinalName, MAX_PATH*sizeof(ucs2char)+sizeof(ucs2char));
      pucs4:=ucs4strnewstr(ext,'UTF-8');
      pucs2:=ucs2strnew(pucs4);
      ucs4strdispose(pucs4);

      resulth:=passocquerystring(ASSOCF_REMAPRUNDLL,DWORD(ASSOCSTR_FRIENDLYAPPNAME),
        pucs2,nil,FinalName,count);
      if resulth = 0 then
        begin
          UCS4FinalName:=ucs4strnewucs2(FinalName);
          assoc.appname:=ucs4strpastoUTF8(UCS4FinalName);
          ucs4strdispose(UCS4FinalName);
        end;
      count:=MAX_PATH;
      resulth:=passocquerystring(ASSOCF_REMAPRUNDLL,DWORD(ASSOCSTR_EXECUTABLE),
        pucs2,nil,FinalName,count);
      if resulth = 0 then
        begin
          UCS4FinalName:=ucs4strnewucs2(FinalName);
          assoc.exename:=ucs4strpastoUTF8(UCS4FinalName);
          ucs4strdispose(UCS4FinalName);
        end;
      count:=MAX_PATH;
      resulth:=passocquerystring(ASSOCF_REMAPRUNDLL,DWORD(ASSOCSTR_FRIENDLYDOCNAME),
        pucs2,nil,FinalName,count);
      if resulth = 0 then
        begin
          UCS4FinalName:=ucs4strnewucs2(FinalName);
          comment:=ucs4strpastoUTF8(UCS4FinalName);
          ucs4strdispose(UCS4FinalName);
        end;
      ucs2strdispose(pucs2);
      Freemem(FinalName, MAX_PATH*sizeof(ucs2char)+sizeof(ucs2char));
    end;
end;


{**************************************************************************}


function utf8strpas(src: pchar): string;
  begin
    if src = nil then
      begin
        utf8strpas:='';
        exit;
      end;
    utf8strpas:=strings.strpas(src);
  end;


  type
  FileRec = System.TFileRec;


  function ucs4strnew(str: pchar; srctype: string): pucs4char;
  var
   i: integer;
   dest: pucs4strarray;
   count: integer;
   Currentindex: integer;
   Outindex,totalsize: integer;
   ch: ucs4char;
   ExtraBytesToRead: integer;
   p:pchararray;
   l: longint;
   endindex: integer;
   idx: integer;
   stringlength: integer;
  begin
    ucs4strnew:=nil;
    dest:=nil;
    srctype:=upstring(srctype);
    p:=nil;
    if not assigned(str) then exit;
    stringlength:=strlen(str);
    { Just a simple null character to add }
    if stringlength = 0 then
      begin
        { Just set a size for the null character }
        Getmem(dest,sizeof(ucs4char));
        dest^[0]:=0;
        ucs4strnew:=pucs4char(dest);
        exit;
      end;
    { Special case: UTF-8 encoding }
    if srctype = 'UTF-8' then
      begin
        { Calculate the length to store the decoded length }
        i:=0;
        totalsize:=0;
        while (str[i]<>#0) do
          begin
            count:=utf8_sizeencoding(str[i]);
            { increment the pointer accordingly }
            inc(i,count);
            inc(totalsize);
          end;
        Getmem(dest,totalsize*sizeof(ucs4char)+sizeof(ucs4char));
{        fillchar(dest^,totalsize*sizeof(ucs4char)+sizeof(ucs4char),$55);}
        i:=0;
        OutIndex := 0;
        while str[i]<>#0 do
          begin
            ch := 0;
            extrabytestoread:= trailingBytesForUTF8[ord(str[i])];
{            if not isLegalUTF8(str, extraBytesToRead+1) then
              begin
                exit;
              end;}
            for idx:=ExtraBytesToRead downto 1 do
              begin
                ch:=ch + ucs4char(str[i]);
                inc(i);
                ch:=ch shl 6;
              end;
            ch:=ch + ucs4char(str[i]);
            inc(i);
            ch := ch - offsetsFromUTF8[extraBytesToRead];
            if (ch <= UNI_MAX_UTF32) then
              begin
                dest^[OutIndex] := ch;
                inc(OutIndex);
              end
            else
              begin
                dest^[OutIndex] := UNI_REPLACEMENT_CHAR;
                inc(OutIndex);
              end;
          end;
        { add null character }
        dest^[outindex]:=0;
        ucs4strnew:=pucs4char(dest);
      end
    else
      begin
        { Search the alias type }
        for i:=1 to MAX_ALIAS do
          begin
            //if aliaslist[i].aliasname = srctype then
              begin
               /// p:=aliaslist[i].table;
                break;
              end;
          end;
        if not assigned(p) then
            exit;
        { Count the number of characters to allocate }
        totalsize:=0;
        count:=stringlength-1;
        for i:=0 to count do
          begin
            l:=p^[str[i]];
            { invalid character }
            if l = UNKNOWN_CODEPOINT then
              continue
            else
              inc(totalsize);
          end;
        { The size to allocate is the same to allocate }
        Getmem(dest,totalsize*sizeof(ucs4char)+sizeof(ucs4char));
        CurrentIndex:=0;
        { Now actually copy the data }
        endindex:=stringlength-1;
        for i:=0 to endindex do
          begin
            l:=p^[str[i]];
            { invalid character }
            if l = UNKNOWN_CODEPOINT then
              begin
                continue
              end
            else
              ch:=ucs4char(l);
            dest^[CurrentIndex]:=ucs4char(ch);
            inc(currentIndex);
          end;
        { add null character }
        dest^[CurrentIndex]:=0;
        ucs4strnew:=pucs4char(dest);
      end;
  end;


function getfileatime(fname: putf8char; var atime: TDateTime): integer;
var
  ResultVal: BOOL;
{$IFNDEF FPC}  
  LastAccessTime: _FILETIME;
{$ELSE}
  LastAccessTime: FILETIME;
{$ENDIF}
  F: File;
  status: integer;
  FileTimeInfo: SYSTEMTIME;
  security : TSecurityAttributes;
  ucs4str: pucs4char;
  ucs2str: pucs2char;
begin
  atime:=0;
  FileAssign(F,utf8strpas(fname));
  status:=FileIOResult;
  if status <> 0 then
    begin
      getfileatime:=status;
      exit;
    end;
  security.nLength := Sizeof(TSecurityAttributes);
  security.bInheritHandle:=true;
  security.lpSecurityDescriptor:=nil;
  
  { Convert the string to a UCS-2 character string }
  ucs4str:=ucs4strnew(fname,'UTF-8');
  ucs2str:=ucs2strnew(ucs4str);
  filerec(f).handle:=longint(CreateFileW (pwidechar(ucs2str),DWORD(FILE_READ_ATTRIBUTES),FILE_SHARE_READ,@security,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0));
  ucs2strdispose(ucs2str);
  ucs4strdispose(ucs4str);
  status:=GetLastError;
  if status <> 0 then
    begin
      getfileatime:=status;
      exit;
    end;
  ResultVal:=GetFileTime(FileRec(F).handle,nil,@LastAccessTime,nil);
  if (LastAccessTime.dwLowDateTime = 0) and (LastAccessTime.dwHighDateTime = 0) then
    begin
      getfileatime:=EXTDOS_STATUS_UNSUPPORTED;
      CloseHandle(filerec(F).handle);
      exit;
    end;

  if ResultVal then
    begin
      ResultVal:=FileTimeToSystemTime(LastAccessTime,FileTimeInfo);
      if ResultVal then
         begin
           if TryEncodeDateTime(FileTimeInfo.wYear,FileTimeInfo.wMonth,FileTimeInfo.wDay,
              FileTimeInfo.wHour, FileTimeInfo.wMinute, FileTimeInfo.wSecond,
              FileTimeInfo.wMilliseconds,atime) then
             status:=EXTDOS_STATUS_OK
           else
             status:=EXTDOS_STATUS_DATE_CONVERT_ERROR;           
         end
      else
         status:=GetLastError;
    end
  else
    status:=GetLastError;
  getfileatime:=status;
  CloseHandle(filerec(F).handle);
  {FileClose(F);}
end;


function getfilectime(fname: putf8char; var ctime: TDateTime): integer;
var
  ResultVal: BOOL;
{$IFNDEF FPC}  
  CreationTime: _FILETIME;
{$ELSE}
  CreationTime: FILETIME;
{$ENDIF}
  F: File;
  status: integer;
  FileTimeInfo: SYSTEMTIME;
begin
  ctime:=0;
  FileAssign(F,utf8strpas(fname));
  status:=FileIOResult;
  if status <> 0 then
    begin
      getfilectime:=status;
      exit;
    end;
  FileReset(F,fmOpenRead);
  status:=FileIOResult;
  if status <> 0 then
    begin
      getfilectime:=status;
      exit;
    end;
  ResultVal:=GetFileTime(FileRec(F).handle,@CreationTime,nil,nil);
  if (CreationTime.dwLowDateTime = 0) and (CreationTime.dwHighDateTime = 0) then
    begin
      getfilectime:=EXTDOS_STATUS_UNSUPPORTED;
      fileio.FileClose(F);
      exit;
    end;
  if ResultVal then
    begin
      ResultVal:=FileTimeToSystemTime(CreationTime,FileTimeInfo);
      if ResultVal then
         begin
           if TryEncodeDateTime(FileTimeInfo.wYear,FileTimeInfo.wMonth,FileTimeInfo.wDay,
              FileTimeInfo.wHour, FileTimeInfo.wMinute, FileTimeInfo.wSecond,
              FileTimeInfo.wMilliseconds,ctime) then
             status:=EXTDOS_STATUS_OK
           else
             status:=EXTDOS_STATUS_DATE_CONVERT_ERROR;
         end
      else
         status:=GetLastError;
    end
  else
    status:=GetLastError;
  getfilectime:=status;
  fileio.FileClose(F);
end;

function getfilemtime(fname: putf8char; var mtime: TDateTime): integer;
var
  ResultVal: BOOL;
{$IFDEF FPC}
  ModificationTime: FILETIME;
{$ELSE}
  ModificationTime: _FILETIME;
{$ENDIF}  
  F: File;
  status: integer;
  FileTimeInfo: SYSTEMTIME;
begin
  mtime:=0;
  FileAssign(F,utf8strpas(fname));
  status:=FileIOResult;
  if status <> 0 then
    begin
      getfilemtime:=status;
      exit;
    end;
  FileReset(F,fmOpenRead);
  status:=FileIOResult;
  if status <> 0 then
    begin
      getfilemtime:=status;
      exit;
    end;
  ResultVal:=GetFileTime(FileRec(F).handle,nil,nil,@ModificationTime);
  if (ModificationTime.dwLowDateTime = 0) and (ModificationTime.dwHighDateTime = 0) then
    begin
      getfilemtime:=EXTDOS_STATUS_UNSUPPORTED;
      fileio.FileClose(F);
      exit;
    end;
  if ResultVal then
    begin
      ResultVal:=FileTimeToSystemTime(ModificationTime,FileTimeInfo);
      if ResultVal then
         begin
           if TryEncodeDateTime(FileTimeInfo.wYear,FileTimeInfo.wMonth,FileTimeInfo.wDay,
              FileTimeInfo.wHour, FileTimeInfo.wMinute, FileTimeInfo.wSecond,
              FileTimeInfo.wMilliseconds,mtime) then
             status:=EXTDOS_STATUS_OK
           else
             status:=EXTDOS_STATUS_DATE_CONVERT_ERROR;
         end
      else
         status:=GetLastError;
    end
  else
    status:=GetLastError;
  getfilemtime:=status;
  fileio.FileClose(F);
end;



 type

SE_OBJECT_TYPE = ( 
    SE_UNKNOWN_OBJECT_TYPE,
    SE_FILE_OBJECT,
    SE_SERVICE,
    SE_PRINTER,
    SE_REGISTRY_KEY,
    SE_LMSHARE,
    SE_KERNEL_OBJECT,
    SE_WINDOW_OBJECT,
    SE_DS_OBJECT,
    SE_DS_OBJECT_ALL,
    SE_PROVIDER_DEFINED_OBJECT,
    SE_WMIGUID_OBJECT
  );

   PPSID = ^PSID;

     _USER_INFO_2 = packed record
     usri2_name: pucs2char;
     usri2_password: pucs2char;
     usri2_password_age: DWORD;
     usri2_priv: DWORD;
     usri2_home_dir: pucs2char;
     usri2_comment: pucs2char;
     usri2_flags: DWORD;
     usri2_script_path: pucs2char;
     usri2_auth_flags: DWORD;
     usri2_full_name: pucs2char;
     usri2_usr_comment: pucs2char;
     usri2_parms: pucs2char;
     usri2_workstations: pucs2char;
     usri2_last_logon: DWORD;
     usri2_last_logoff: DWORD;
     usri2_acct_expires: DWORD;
     usri2_max_storage: DWORD;
     usri2_units_per_week: DWORD;
     usri2_logon_hours: pchar;
     usri2_bad_pw_count: DWORD;
     usri2_num_logons: DWORD;
     usri2_logon_server: pucs2char;
     usri2_country_code: DWORD;
     usri2_code_page: DWORD;
   end;

   P_USER_INFO_2 = ^_USER_INFO_2;
   


  tgetnamedsecurityinfow = function (pObjectName: PWideChar; ObjectType: SE_OBJECT_TYPE;
         SecurityInfo: SECURITY_INFORMATION; ppsidOwner, ppsidGroup: PPSID; ppDacl, ppSacl: PACL;
         var ppSecurityDescriptor: PSECURITY_DESCRIPTOR): DWORD; stdcall;
   tlookupaccountsidw = function (lpSystemName: PWideChar; Sid: PSID;
       Name: PWideChar; var cbName: DWORD; ReferencedDomainName: PWideChar;
       var cbReferencedDomainName: DWORD; var peUse: SID_NAME_USE): BOOL; stdcall;

   tnetusergetinfo = function (servername: pwidechar;
     username: pwidechar; level: DWORD; var buffer: P_USER_INFO_2): DWORD; stdcall;

  const
  {** Maximum length of unicode buffers }
 MAX_UNICODE_BUFSIZE = 63;
 MAX_PATH = 255;
 MIN_FILE_YEAR = 1601; //3000;

function getfileowner(fname: putf8char): utf8string;
var
  PGetNamedSecurityInfoW: tgetnamedsecurityinfoW;
  PLookupAccountSidw: tlookupaccountsidw;
  sidOwner: PSID;
  ppSecurityDescriptor: PSECURITY_DESCRIPTOR;
  status: DWORD;
  AccountName: pwidechar;
  AccountNameLen: ULONG;
  DomainName: pwidechar;
  DomainNameLen: ULONG;
  FinalUserName: array[0..MAX_UNICODE_BUFSIZE-1] of ucs4char;
  peUse: SID_NAME_USE;
  resultval: BOOL;
  ucs4str: pucs4char;
  ucs2str: pucs2char;
  p: pointer;
  s: string;
  i: integer;
begin
  getfileowner:='';
  if not assigned(pointer(AdvApi32Handle)) then exit;
  p:=(GetProcAddress(AdvApi32Handle,'GetNamedSecurityInfoW'));
  PGetNamedSecurityInfoW:=tgetnamedsecurityinfoW(p);
  if not assigned(p) then exit;
  ppSecurityDescriptor:=nil;
  ucs4str:=ucs4strnew(fname,'UTF-8');
  ucs2str:=ucs2strnew(ucs4str);
  status:=PGetNamedSecurityInfoW(pwidechar(ucs2str), SE_FILE_OBJECT, OWNER_SECURITY_INFORMATION,@sidOwner,nil,nil,nil,ppSecurityDescriptor);
  ucs2strdispose(ucs2str);
  ucs4strdispose(ucs4str);
  
  if status = ERROR_SUCCESS then
    begin
       AccountNameLen:= MAX_UNICODE_BUFSIZE;
       DomainNameLen:=MAX_UNICODE_BUFSIZE;
       GetMem(AccountName,MAX_UNICODE_BUFSIZE*sizeof(widechar)+sizeof(widechar));
       GetMem(DomainName,MAX_UNICODE_BUFSIZE*sizeof(widechar)+sizeof(widechar));
       p:=GetProcAddress(AdvApi32Handle,'LookupAccountSidW');
       if assigned(p) then
         begin
          pLookupAccountSidW:=tLookupAccountSidW(p);
          resultval:=pLookupAccountSidW(nil,sidowner,AccountName,AccountNameLen,
             DomainName,DomainNameLen,peUse);
          status:=GetLastError;
          if resultval then
            begin
              { Convert the value to an UTF-8 string }
              for i:=0 to MAX_UNICODE_BUFSIZE-1 do
                Begin
                  FinalUserName[i]:=ucs4char(word(AccountName[i]));
                end;
              s:=ucs4strpastoUTF8(pucs4char(@FinalUserName[0]));
              { EVERYONE indicates unknown owner }
              if upstring(s) = 'EVERYONE' then
               s:='';
              getfileowner:=s;
            end;
         end;
       FreeMem(AccountName,MAX_UNICODE_BUFSIZE*sizeof(widechar)+sizeof(widechar));
       FreeMem(DomainName,MAX_UNICODE_BUFSIZE*sizeof(widechar)+sizeof(widechar));
    end;
  if assigned(ppSecurityDescriptor) then
    LocalFree(HLOCAL(ppSecurityDescriptor));
end;

function SetFileTime(hFile: THandle;
  lpCreationTime, lpLastAccessTime, lpLastWriteTime: PFileTime): BOOL; stdcall;
        external 'kernel32.dll' name 'SetFileTime';


function setfileatime(fname: putf8char; newatime: tdatetime): integer;
const
  FILE_WRITE_ATTRIBUTES = $100;
var
  ResultVal: BOOL;
  LastAccessTime: FILETIME;
  status: integer;
  FileTimeInfo: SYSTEMTIME;
  security : TSecurityAttributes;
  FileHandle: THandle;
  ucs4str: pucs4char;
  ucs2str: pucs2char;
begin
{ We must open the file with a special access mode not

  modify the last access time. }
  security.nLength := Sizeof(TSecurityAttributes);
  security.bInheritHandle:=true;
  security.lpSecurityDescriptor:=nil;

  ucs4str:=ucs4strnew(fname,'UTF-8');
  ucs2str:=ucs2strnew(ucs4str);
  FileHandle:=CreateFileW(pwidechar(ucs2str),FILE_WRITE_ATTRIBUTES,FILE_SHARE_READ,@security,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
  ucs2strdispose(ucs2str);
  ucs4strdispose(ucs4str);

  status:=0;
  if (FileHandle=0) or (FileHandle=$FFFFFFFF) then
    begin
      status:=GetLastError;
    end;
  if status <> 0 then
    begin
      setfileatime:=status;
      exit;
    end;
  DecodeDateTime(newatime, FileTimeInfo.wYear,
    FileTimeInfo.wMonth, FileTimeInfo.wDay,
    FileTimeInfo.wHour, FileTimeInfo.wMinute,
    FileTimeInfo.wSecond, FileTimeInfo.wMilliSeconds);
  { Check if this is a valid year or not }
  if FileTimeInfo.wYear < MIN_FILE_YEAR then
    begin
      setfileatime:=EXTDOS_STATUS_DATE_UNSUPPORTED;
      CloseHandle(FileHandle);
      exit;
    end;
  ResultVal:=SystemTimeToFileTime(FileTimeInfo,LastAccessTime);
  if ResultVal then
    begin
      ResultVal:=SetFileTime(FileHandle,nil,@LastAccessTime,nil);
      if ResultVal then
        status:=EXTDOS_STATUS_OK
      else
        status:=GetLastError;
    end
  else
    begin
       setfileatime:=GetLastError;
       CloseHandle(FileHandle);
       exit; 
    end;
  setfileatime:=status;
  CloseHandle(FileHandle);
end;


function setfilemtime(fname: putf8char; newmtime: tdatetime): integer;
var
  ResultVal: BOOL;
  LastWriteTime: FILETIME;
  F: File;
  status: integer;
  FileTimeInfo: SYSTEMTIME;
begin
  FileAssign(F,utf8strpas(fname));
  status:=FileIOResult;
  if status <> 0 then
    begin
      setfilemtime:=status;
      exit;
    end;
  FileReset(F,fmOpenReadWrite);
  status:=FileIOResult;
  if status <> 0 then
    begin
      setfilemtime:=status;
      exit;
    end;
  DecodeDateTime(newmtime, FileTimeInfo.wYear,
    FileTimeInfo.wMonth, FileTimeInfo.wDay,
    FileTimeInfo.wHour, FileTimeInfo.wMinute,
    FileTimeInfo.wSecond, FileTimeInfo.wMilliSeconds);
  { Check if this is a valid year or not }
  if FileTimeInfo.wYear < MIN_FILE_YEAR then
    begin
      setfilemtime:=EXTDOS_STATUS_DATE_UNSUPPORTED;
      fileio.FileClose(F);
      exit;
    end;
  ResultVal:=SystemTimeToFileTime(FileTimeInfo,LastWriteTime);
  if ResultVal then
    begin
      ResultVal:=SetFileTime(FileRec(F).handle,nil,nil,@LastWriteTime);
      if ResultVal then
        status:=EXTDOS_STATUS_OK
      else
        status:=GetLastError;
    end
  else
    begin
       setfilemtime:=GetLastError;
       fileio.FileClose(F);
       exit;
    end;
  setfilemtime:=status;
  fileio.FileClose(F);
end;


function setfilectime(fname: putf8char; newctime: tdatetime): integer;
var
  ResultVal: BOOL;
  CreationTime: FILETIME;
  F: File;
  status: integer;
  FileTimeInfo: SYSTEMTIME;
begin
  FileAssign(F,utf8strpas(fname));
  status:=FileIOResult;
  if status <> 0 then
    begin
      setfilectime:=status;
      exit;
    end;
  FileReset(F,fmOpenReadWrite);
  status:=FileIOResult;
  if status <> 0 then
    begin
      setfilectime:=status;
      exit;
    end;
  DecodeDateTime(newctime, FileTimeInfo.wYear, 
    FileTimeInfo.wMonth, FileTimeInfo.wDay, 
    FileTimeInfo.wHour, FileTimeInfo.wMinute,
    FileTimeInfo.wSecond, FileTimeInfo.wMilliSeconds);
  { Check if this is a valid year or not }
  if FileTimeInfo.wYear < MIN_FILE_YEAR then
    begin
      setfilectime:=EXTDOS_STATUS_DATE_UNSUPPORTED;
      fileio.FileClose(F);
      exit;    
    end;
  ResultVal:=SystemtimeToFileTime(FileTimeInfo,CreationTime);
  if ResultVal then
    begin
      ResultVal:=SetFileTime(FileRec(F).handle,@CreationTime,nil,nil);
      if ResultVal then
        status:=EXTDOS_STATUS_OK
      else
        status:=GetLastError;
    end
  else
    begin
       setfilectime:=GetLastError;
       fileio.FileClose(F);
       exit;
    end;
  setfilectime:=status;
  fileio.FileClose(F);
end;


//  type
  //FileRec = System.TFileRec;
const
  Filenamelen = 255;
Type
{ Needed for Win95 LFN Support }
  ComStr  = String[Filenamelen];
  PathStr = String[Filenamelen];
  DirStr  = String[Filenamelen];
  NameStr = String[Filenamelen];
  ExtStr  = String[Filenamelen];


procedure GetDirIO (DriveNr: byte; var Dir: OpenString);

(* GetDirIO is supposed to return the root of the given drive   *)
(* in case of an error for compatibility of FExpand with TP/BP. *)

var
  OldInOutRes: word;
begin
  OldInOutRes := IOResult;
  GetDir (DriveNr, Dir);
end;


  const
//{$IFDEF WIN32}
 LineEnding : string = #13#10;
 LFNSupport = TRUE;
 DirectorySeparator = '\';
 DriveSeparator = ':';
 PathSeparator = ';';
 ExtensionSeparator = '-';
 FileNameCaseSensitive = FALSE;

  function FExpand (const Path: PathStr): PathStr;

(* LFNSupport boolean constant, variable or function must be declared for all
   the platforms, at least locally in the Dos unit implementation part.
   In addition, FPC_FEXPAND_UNC, FPC_FEXPAND_DRIVES, FPC_FEXPAND_GETENV_PCHAR,
   , ,
   conditionals might
   be defined to specify FExpand behaviour.
*)

//const FileNameCaseSensitive  = false;



{$IFDEF FPC_FEXPAND_DRIVES}
var
    PathStart: longint;
{$ELSE FPC_FEXPAND_DRIVES}
const
    PathStart = 1;
{$ENDIF FPC_FEXPAND_DRIVES}
{$IFDEF FPC_FEXPAND_UNC}
var
    RootNotNeeded: boolean;
{$ELSE FPC_FEXPAND_UNC}
const
    RootNotNeeded = false;
{$ENDIF FPC_FEXPAND_UNC}

var S, Pa, Dirs: PathStr;
    I, J: longint;

begin
{$IFDEF FPC_FEXPAND_UNC}
    RootNotNeeded := false;
{$ENDIF FPC_FEXPAND_UNC}

(* First convert the path to uppercase if appropriate for current platform. *)
    if FileNameCaseSensitive then
        Pa := Path
    else
    begin
        Pa:='';
        for i:=1 to length(Path) do
          Pa := Pa + UpCase (Path[i]);
    end;    

(* Allow both '/' and '\' as directory separators *)
(* by converting all to the native one.           *)
    if DirectorySeparator = '\' then
    {Allow slash as backslash}
        begin
            for I := 1 to Length (Pa) do
                if Pa [I] = '/' then
                    Pa [I] := DirectorySeparator
        end
    else
    {Allow backslash as slash}
        begin
            for I := 1 to Length (Pa) do
                if Pa [I] = '\' then
                    Pa [I] := DirectorySeparator;
        end;

(* PathStart is amount of characters to strip to get beginning *)
(* of path without volume/drive specification.                 *)
{$IFDEF FPC_FEXPAND_DRIVES}
    PathStart := 3;
{$ENDIF FPC_FEXPAND_DRIVES}

(* Expand tilde to home directory if appropriate. *)

(* Do we have a drive/volume specification? *)
    if (Length (Pa) > 1) and (Pa [1] in ['A'..'Z', 'a'..'z']) and
                                                 (Pa [2] = DriveSeparator) then
        begin

(* We need to know current directory on given *)
(* volume/drive _if_ such a thing is defined. *)
{$IFDEF FPC_FEXPAND_DRIVES}
 {$IFNDEF FPC_FEXPAND_NO_DEFAULT_PATHS}
            { Always uppercase driveletter }
            if (Pa [1] in ['a'..'z']) then
                Pa [1] := Chr (Ord (Pa [1]) and not ($20));
            GetDirIO (Ord (Pa [1]) - Ord ('A') + 1, S);

(* Do we have more than just drive/volume specification? *)
            if Length (Pa) = Pred (PathStart) then

(* If not, just use the current directory for that drive/volume. *)
                Pa := S
            else

(* If yes, find out whether the following path is relative or absolute. *)
                if Pa [PathStart] <> DirectorySeparator then
                    if Pa [1] = S [1] then
                        begin
                            { remove ending slash if it already exists }
                            if S [Length (S)] = DirectorySeparator then
                                Dec (S [0]);
                            Pa := S + DirectorySeparator +
                              Copy (Pa, PathStart, Length (Pa) - PathStart + 1)
                        end
                    else
                        Pa := Pa [1] + DriveSeparator + DirectorySeparator +
                              Copy (Pa, PathStart, Length (Pa) - PathStart + 1)
 {$ENDIF FPC_FEXPAND_NO_DEFAULT_PATHS}
        end
    else
{$ELSE FPC_FEXPAND_DRIVES}

(* If drives are not supported, but a drive *)
(* was supplied anyway, ignore (remove) it. *)
            Delete (Pa, 1, 2);
        end;
    {Check whether we don't have an absolute path already}
    if (Length (Pa) >= PathStart) and (Pa [PathStart] <> DirectorySeparator) or
                                                 (Length (Pa) < PathStart) then
{$ENDIF FPC_FEXPAND_DRIVES}
        begin

(* Get current directory on selected drive/volume. *)
            GetDirIO (0, S);

(* Do we have an absolute path? *)
{$IFDEF FPC_FEXPAND_DRIVES}
            if (Length (Pa) > 0)
                                 and (Pa [1] = DirectorySeparator)
                                                                   then
                begin
 {$IFDEF FPC_FEXPAND_UNC}
                    {Do not touch network drive names}
                    if (Length (Pa) > 1) and (Pa [2] = DirectorySeparator)
                                                            and LFNSupport then
                        begin
                            PathStart := 3;
                            {Find the start of the string of directories}
                            while (PathStart <= Length (Pa)) and
                                      (Pa [PathStart] <> DirectorySeparator) do
                                Inc (PathStart);
                            if PathStart > Length (Pa) then
                            {We have just a machine name...}
                                if Length (Pa) = 2 then
                                {...or not even that one}
                                    PathStart := 2
                                else
                                    Pa := Pa + DirectorySeparator                            else
                                if PathStart < Length (Pa) then
                                {We have a resource name as well}
                                    begin
                                        RootNotNeeded := true;
                                        {Let's continue in searching}
                                        repeat
                                            Inc (PathStart);
                                        until (PathStart > Length (Pa)) or
                                         (Pa [PathStart] = DirectorySeparator);
                                    end;
                        end
                    else
 {$ENDIF FPC_FEXPAND_UNC}
                        Pa := S [1] + DriveSeparator + Pa;
                end
            else
{$ENDIF FPC_FEXPAND_DRIVES}

                (* We already have a slash if root is the curent directory. *)
                if Length (S) = PathStart then
                    Pa := S + Pa
                else

                    (* We need an ending slash if FExpand was called  *)
                    (* with an empty string for compatibility, except *)
                    (* for platforms where this is invalid.           *)
                    if Length (Pa) = 0 then
                        Pa := S + DirectorySeparator
                    else
                        Pa := S + DirectorySeparator + Pa;
        end;

    {Get string of directories to only process relative references on this one}
    Dirs := Copy (Pa, Succ (PathStart), Length (Pa) - PathStart);

    {First remove all references to '\.\'}
    I := Pos (DirectorySeparator + '.' + DirectorySeparator, Dirs);
    while I <> 0 do
        begin
            Delete (Dirs, I, 2);
            I := Pos (DirectorySeparator + '.' + DirectorySeparator, Dirs);
        end;

    {Now remove also all references to '\..\' + of course previous dirs..}
    I := Pos (DirectorySeparator + '..' + DirectorySeparator, Dirs);
    while I <> 0 do
        begin
            J := Pred (I);
            while (J > 0) and (Dirs [J] <> DirectorySeparator) do
                Dec (J);
            Delete (Dirs, Succ (J), I - J + 3);
            I := Pos (DirectorySeparator + '..' + DirectorySeparator, Dirs);
        end;


    {Then remove also a reference to '\..' at the end of line
    + the previous directory, of course,...}
    I := Pos (DirectorySeparator + '..', Dirs);
    if (I <> 0) and (I = Length (Dirs) - 2) then
        begin
            J := Pred (I);
            while (J > 0) and (Dirs [J] <> DirectorySeparator) do
                Dec (J);
            if (J = 0) then
                Dirs := ''
            else
                Delete (Dirs, Succ (J), I - J + 2);
        end;


    {...and also a possible reference to '\.'}
    if (Length (Dirs) = 1) then
        begin
            if (Dirs [1] = '.') then
            {A special case}
                Dirs := ''
        end
    else
        if (Length (Dirs) <> 0) and (Dirs [Length (Dirs)] = '.') and
                        (Dirs [Pred (Length (Dirs))] = DirectorySeparator) then
            Dec (Dirs [0], 2);

    {Finally remove '.\' at the beginning of the string of directories...}
    while (Length (Dirs) >= 2) and (Dirs [1] = '.')
                                         and (Dirs [2] = DirectorySeparator) do
        Delete (Dirs, 1, 2);


    {...and possible (invalid) references to '..\' as well}
    while (Length (Dirs) >= 3) and (Dirs [1] = '.') and (Dirs [2] = '.') and
                                             (Dirs [3] = DirectorySeparator) do
        Delete (Dirs, 1, 3);

    {Two special cases - '.' and '..' alone}
    if (Length (Dirs) = 1) and (Dirs [1] = '.') then
        Dirs := '';
    if (Length (Dirs) = 2) and (Dirs [1] = '.') and (Dirs [2] = '.') then
        Dirs := '';

    {Join the parts back to create the complete path}
    if Length (Dirs) = 0 then
        begin
            Pa := Copy (Pa, 1, PathStart);
            if Pa [PathStart] <> DirectorySeparator then
                Pa := Pa + DirectorySeparator;
        end
    else
        Pa := Copy (Pa, 1, PathStart) + Dirs;

    {Remove ending \ if not supplied originally, the original string
    wasn't empty (to stay compatible) and if not really needed}
    if (Pa [Length (Pa)] = DirectorySeparator)
         and ((Length (Pa) > PathStart) or
            (RootNotNeeded and (Length (Pa) = PathStart))) and
                     (Length (Path) <> 0)
                          and (Path [Length (Path)] <> DirectorySeparator) then
        Dec (Pa [0]);

    FExpand := Pa;
end;


Procedure FSplit (Path: PathStr; var Dir: DirStr; var Name: NameStr; var Ext: ExtStr);
var
  DirEnd, ExtStart: Longint;
const
 DirectorySeparator = '\';
 DriveSeparator = ':';
 LFNSupport = true;  
begin
  {** Remove Double quote characters **}
  if path[length(path)] = '"' then
   delete(path,length(path),1);
  if path[1] = '"' then
   delete(path,1,1);

  if DirectorySeparator = '/' then
  { allow backslash as slash }
    for DirEnd := 1 to Length (Path) do
      begin
        if Path [DirEnd] = '\' then Path [DirEnd] := DirectorySeparator
      end
  else
    if DirectorySeparator = '\' then
    { allow slash as backslash }
      for DirEnd := 1 to Length (Path) do
        if Path [DirEnd] = '/' then Path [DirEnd] := DirectorySeparator;

{ Find the first DirectorySeparator or DriveSeparator from the end. }
  DirEnd := Length (Path);
{ Avoid problems with platforms having DriveSeparator = DirectorySeparator. }
  if DirectorySeparator = DriveSeparator then
   while (DirEnd > 0) and (Path [DirEnd] <> DirectorySeparator) do
    Dec (DirEnd)
  else
   while (DirEnd > 0) and
                 (Path [DirEnd] <> DirectorySeparator) and
                                           (Path [DirEnd] <> DriveSeparator) do
    Dec (DirEnd);

{ The first "extension" should be returned if LFN }
{ support not available, the last one otherwise.  }
  if LFNSupport then
    begin
      ExtStart := Length (Path);
      while (ExtStart > DirEnd) and (Path [ExtStart] <> ExtensionSeparator) do
        Dec (ExtStart);
      if ExtStart = 0 then
        ExtStart := Length (Path) + 1
      else
        if Path [ExtStart] <> ExtensionSeparator then
          ExtStart := Length (Path) + 1;
    end
  else
    begin
      ExtStart := DirEnd + 1;
      while (ExtStart <= Length (Path)) and (Path [ExtStart] <> ExtensionSeparator) do
        Inc (ExtStart);
    end;

  Dir := Copy (Path, 1, DirEnd);
  Name := Copy (Path, DirEnd + 1, ExtStart - DirEnd - 1);
  Ext := Copy (Path, ExtStart, Length (Path) - ExtStart + 1);
end;





function getfilestats(fname: putf8char; var stats: TFileStats): integer;
var
 F: file;
 ResultVal: BOOL;
 ucs2str: pucs2char;
 ucs4str: pucs4char;
 info: BY_HANDLE_FILE_INFORMATION;
 name: namestr; //string; //((namestr;
 status: integer;
 dir: dirstr;
 ext: extstr;
 FileTimeInfo: SYSTEMTIME;
 security : TSecurityAttributes;
 s: string;
begin
  fillchar(stats,sizeof(stats),#0);
  ucs4str:=ucs4strnew(fname,'UTF-8');
  ucs2str:=ucs2strnew(ucs4str);
  security.nLength := Sizeof(TSecurityAttributes);
  security.bInheritHandle:=true;
  security.lpSecurityDescriptor:=nil;
  filerec(f).handle:=longint(CreateFileW (pwidechar(ucs2str),DWORD(GENERIC_READ),FILE_SHARE_READ,@security,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0));
  ucs2strdispose(ucs2str);
  ucs4strdispose(ucs4str);
  status:=GetLastError;
  if status <> 0 then
    begin
      getfilestats:=status;
      exit;
    end;
{$IFDEF FPC}
  ResultVal:=GetFileInformationByHandle(FileRec(F).handle,@info);
{$ELSE}
  ResultVal:=GetFileInformationByHandle(FileRec(F).handle,info);
{$ENDIF}
  if ResultVal then
    begin
      {***** Unsupported information ****}
      stats.accesses:=-1;
      stats.streamcount:=-1;
      {***** Supported returned information ****}
      stats.utc:=true;
      s:=hexstr(longint(info.dwVolumeSerialNumber),8);
      move(s[1],stats.dev[0],length(s));
      { Now the file serial number }
      s:=hexstr(longint(info.nFileIndexLow),8);
      move(s[1],stats.ino[0],length(s));
      s:=hexstr(longint(info.nFileIndexHigh),8);
      move(s[1],stats.ino[8],length(s));
      {** Name of the resource on disk }
      s:=strpas(fname);
      s:=FExpand(s);
      FSplit(s,dir,name,ext);
      s:=name+ext;
      stats.name:=s;
      stats.dirstr:=dir;
      
      { Fill up shell file assocations and comment strings }
      GetShellAssociationInfo(ext,stats.association,stats.comment);
      stats.nlink:=info.nNumberOfLinks;
      stats.attributes:=WinAttrToExtAttr(info.dwFileAttributes);
      { Check for special devices }
      if IsDevice(stats.name) then
        begin
          Include(stats.attributes, attr_device);
        end;
      stats.owner:=getfileowner(fname);
      stats.size:=getfilesize(fname);
      ResultVal:=FileTimeToSystemTime(info.ftLastWriteTime,FileTimeInfo);
      { Error if value is exactly zero, probably indicates that this FileSystem
        does not support this timestamp }
      if ResultVal and not
      ((info.ftLastWriteTime.dwLowDateTime = 0) and (info.ftLastWriteTime.dwHighDateTime = 0)
      ) then
         begin
           if TryEncodeDateTime(FileTimeInfo.wYear,FileTimeInfo.wMonth,FileTimeInfo.wDay,
              FileTimeInfo.wHour, FileTimeInfo.wMinute, FileTimeInfo.wSecond,
              FileTimeInfo.wMilliseconds,stats.mtime) then
         end;
      ResultVal:=FileTimeToSystemTime(info.ftCreationTime,FileTimeInfo);
      if ResultVal and not
      ((info.ftCreationTime.dwLowDateTime = 0) and (info.ftCreationTime.dwHighDateTime = 0)
      ) then
         begin
           if TryEncodeDateTime(FileTimeInfo.wYear,FileTimeInfo.wMonth,FileTimeInfo.wDay,
              FileTimeInfo.wHour, FileTimeInfo.wMinute, FileTimeInfo.wSecond,
              FileTimeInfo.wMilliseconds,stats.ctime) then
             status:=EXTDOS_STATUS_OK;
         end;
      ResultVal:=FileTimeToSystemTime(info.ftLastAccessTime,FileTimeInfo);
      if ResultVal and not
      ((info.ftLastAccessTime.dwLowDateTime = 0) and (info.ftLastAccessTime.dwHighDateTime = 0)
      ) then
         begin
           if TryEncodeDateTime(FileTimeInfo.wYear,FileTimeInfo.wMonth,FileTimeInfo.wDay,
              FileTimeInfo.wHour, FileTimeInfo.wMinute, FileTimeInfo.wSecond,
              FileTimeInfo.wMilliseconds,stats.atime) then
             status:=EXTDOS_STATUS_OK;
         end;
    end
  else
     getfilestats:=GetLastError;
  CloseHandle(FileRec(f).handle);
end;


function getfilesize(fname: putf8char): big_integer_t;
var
 F: File;
 status: integer;
begin
  FileAssign(F,utf8strpas(fname));
  status:=FileIOResult;
  if status <> 0 then
    begin
      getfilesize:=big_integer_t(-1);
      exit;
    end;
  FileReset(F,fmOpenRead);
  status:=FileIOResult;
  if status <> 0 then
    begin
      getfilesize:=big_integer_t(-1);
      exit;
    end;
  getfilesize:=FileGetSize(F);
  fileio.FileClose(F);
end;


function utf8_length(const s: utf8string): integer;
  begin
   utf8_length:=length(s);
  end;

function utf8strnewstr(str: utf8string): putf8char;
 var
  p: putf8char;
 begin
   utf8strnewstr:=nil;
   p:=nil;
   if utf8_length(str) > 0 then
     begin
        getmem(p,utf8_length(str)+sizeof(utf8char));
        strpcopy(p,str);
        utf8strnewstr:=p;
     end;
 end;


  function utf8strdispose(p: pchar): pchar;
  begin
    utf8strdispose := nil;
    if not assigned(p) then
      exit;
    Freemem(p,strlen(p)+1);
    p:=nil;
  end;


function DirectoryExists(DName : utf8string): Boolean;
var
 utf: putf8char;
 searchinfo: TSearchRecExt;
 Volume: boolean;
 status: integer;
begin
  Volume:=false;
  DirectoryExists:=false;
  { Special handling for volume }
  if (length(dname) = 3) and (dname[2] = ':') then
    begin
      Volume:=true;
      Dname:=dname+'*';
    end
  else
    begin
      if Dname[length(Dname)] = DirectorySeparator then
        delete(DName,length(DName),1);
    end;
  utf:=utf8strnewstr(dname);
  if not volume then
    begin
     status:=FindFirstEx(utf,[attr_directory],SearchInfo);
     if (status = 0) and ((attr_directory in SearchInfo.stats.Attributes)) then
       begin
          DirectoryExists:=true;
       end;
    end
  else
    begin
       status:=FindFirstEx(utf,[attr_any],SearchInfo);
       if status = 0 then
         begin
          DirectoryExists:=true;
         end;
    end;
  FindCloseEx(SearchInfo);
  utf8strdispose(utf);
end;


function FileExists(const FName : utf8string): Boolean;
var
 utf: putf8char;
 searchinfo: TSearchRecExt;
 status: integer;
begin
  FileExists:=false;
  utf:=utf8strnewstr(fname);
  status:=FindFirstEx(utf,[attr_any],SearchInfo);
  if status = 0 then
    begin
      if not
         (
         (attr_directory in SearchInfo.stats.Attributes) or
         (attr_device in SearchInfo.stats.Attributes) or
         (attr_offline in SearchInfo.stats.Attributes)
         )
         then
         FileExists:=true;
    end;
  FindCloseEx(SearchInfo);  
  utf8strdispose(utf);
end;




function getuserfullname(account: utf8string): utf8string;
var
 p: pointer;
 wc: pucs2char;
 ucs4accountname: pucs4char;
 ui: P_USER_INFO_2;
 pnetusergetinfo: tnetusergetinfo;
 UCS4FinalName: pucs4char;
begin
  getuserfullname:='';
  if not assigned(pointer(NetApi32Handle)) then exit;
  p:=(GetProcAddress(NetApi32Handle,'NetUserGetInfo'));
  PNetUserGetInfo:=tnetusergetinfo(p);
  if not assigned(p) then exit;
  { Convert the account name to UCS-2 }
  ucs4accountname:=ucs4strnewstr(account,'UTF-8');
  wc:=ucs2strnew(ucs4accountname);
  ucs4strdispose(ucs4accountname);
  { Success on 0 }
  if PNetUserGetInfo(nil,pwidechar(wc),2,ui) =0 then
    begin
       UCS4FinalName:=ucs4strnewucs2(ui^.usri2_full_name);
       getuserfullname:=ucs4strpastoUTF8(UCS4FinalName);
       ucs4strdispose(UCS4Finalname);
    end;
  ucs2strdispose(wc);  
end;


function getfileattributes(fname: putf8char): tresourceattributes;
var
 ucs4str: pucs4char;
 ucs2str: pucs2char;
 attributes: DWORD;
 outattributes: tresourceattributes;
 Dir: DirStr;
 Name: NameStr;
 Ext: ExtStr;
begin
  ucs4str:=ucs4strnew(fname,'UTF-8');
  outattributes:=[];
  getfileattributes:=outattributes;
  if assigned(ucs4str) then
    begin
      ucs2str:=ucs2strnew(ucs4str);
      if assigned(ucs2str) then
        begin
          attributes:=GetFileAttributesW(pwidechar(ucs2str));
          { convert the attributes to our format }
          outattributes:=WinAttrToExtAttr(attributes);
          FSplit(utf8strpas(fname),Dir,Name,Ext);
          if IsDevice(Name+Ext) then
            begin
              Include(outAttributes,attr_device);  
            end;
          ucs2strdispose(ucs2str);
        end;
      ucs4strdispose(ucs4str);
    end;
  GetFileAttributes:=outattributes;
end;

function GetCurrentDirectory(var DirStr: utf8string): boolean;
var
 ucs4str: pucs4char;
 ucs2str: pucs2char;
 resultval: DWORD;
begin
  GetCurrentDirectory:=false;
  DirStr:='';
  GetMem(ucs2str,MAX_PATH*sizeof(ucs2char));
  if assigned(ucs2str) then
    begin
      resultval:=GetCurrentDirectoryW(MAX_PATH,pwidechar(ucs2str));
      if resultval <= (MAX_PATH) then
        begin
            GetcurrentDirectory:=true;
            ucs4str:=ucs4strnewucs2(ucs2str);
            DirStr:=ucs4strpastoutf8(ucs4str);
            ucs4strdispose(ucs4str);
        end;
    end;
  FreeMem(ucs2str,MAX_PATH*sizeof(ucs2char));
end;

function SetCurrentDirectory(const DirStr: utf8string): boolean;
var
 ucs4str: pucs4char;
 ucs2str: pucs2char;
 resultval: bool;
begin
  SetCurrentDirectory:=false;
  ucs4str:=ucs4strnewstr(DirStr,'UTF-8');
  if assigned(ucs4str) then
    begin
      ucs2str:=ucs2strnew(ucs4str);
      if assigned(ucs2str) then
        begin
          resultval:=SetCurrentDirectoryW(pwidechar(ucs2str));
          if resultval then
            SetcurrentDirectory:=true;
          ucs2strdispose(ucs2str);
        end;
      ucs4strdispose(ucs4str);
    end;
end;

{**********************************************************************}
{                      FindFirstEx/FindNextExt                         }
{**********************************************************************}


function FindMatch(var f:TSearchRecExt): integer;
var
 FileTimeInfo: SYSTEMTIME;
 p: pchar;
 s:string;
 dir:dirstr;
 name:namestr;
 ext:extstr;
 ucs4str: pucs4char;
 ResultVal: BOOL;
begin
  FindMatch:=0;
  { Find file with correct attribute }
  While
   ((F.W32FindData.dwFileAttributes and F.IncludeAttr)=0) and (not (attr_any in F.SearchAttr)) do
   begin
     if not FindNextFileW (F.FindHandle,F.W32FindData) then
      begin
        FindMatch:=GetLastError;
        exit;
      end;
   end;

(*
    {** number of parallel streams for this resource *}
    streamcount: integer;*)
  {************ unsupported ***************}
  f.stats.accesses:=-1;
  f.stats.nlink:=-1;

  { Convert to Unicode }
  ucs4str:=ucs4strnewucs2(@F.W32FindData.cFileName);
  f.stats.name:=ucs4strpastoUTF8(ucs4str);
  s:=f.stats.dirstr+f.stats.name;
  FSplit(s,dir,name,ext);
  GetShellAssociationInfo(ext,f.stats.association,f.stats.comment);
  Getmem(p,length(s)+1);
  strpcopy(p,s);
  f.stats.owner:=getfileowner(p);
  FreeMem(p,length(s)+1);
  { Convert some attributes back }
  f.stats.size:=F.W32FindData.NFileSizeLow;
  f.stats.utc:=true;
  f.stats.attributes:=WinAttrToExtAttr(F.W32FindData.dwFileAttributes);
  { Check for special devices }
  if IsDevice(f.stats.name) then
    begin
      Include(f.stats.attributes, attr_device);
    end;
  { Convert to correct time data }
  ResultVal := FileTimeToSystemTime(F.W32FindData.ftLastWriteTime,FileTimeInfo);
  if ResultVal and not
    ((F.W32FindData.ftLastWriteTime.dwLowDateTime = 0) and (F.W32FindData.ftLastWriteTime.dwHighDateTime = 0)
    ) then
    begin
      TryEncodeDateTime(FileTimeInfo.wYear,FileTimeInfo.wMonth,FileTimeInfo.wDay,
              FileTimeInfo.wHour, FileTimeInfo.wMinute, FileTimeInfo.wSecond,
              FileTimeInfo.wMilliseconds,f.stats.mtime);
    end;
  ResultVal:=FileTimeToSystemTime(F.W32FindData.ftCreationTime,FileTimeInfo);
  { Error if value is exactly zero, probably indicates that this FileSystem
    does not support this timestamp }
  if ResultVal and not
    ((F.W32FindData.ftCreationTime.dwLowDateTime = 0) and (F.W32FindData.ftCreationTime.dwHighDateTime = 0)
    ) then
    begin
      TryEncodeDateTime(FileTimeInfo.wYear,FileTimeInfo.wMonth,FileTimeInfo.wDay,
              FileTimeInfo.wHour, FileTimeInfo.wMinute, FileTimeInfo.wSecond,
              FileTimeInfo.wMilliseconds,f.stats.ctime);
    end;
  ResultVal:=FileTimeToSystemTime(F.W32FindData.ftLastAccessTime,FileTimeInfo);
  { Error if value is exactly zero, probably indicates that this FileSystem
    does not support this timestamp }
  if ResultVal and not
    ((F.W32FindData.ftLastAccessTime.dwLowDateTime = 0) and (F.W32FindData.ftLastAccessTime.dwHighDateTime = 0)
    ) then
    begin
      TryEncodeDateTime(FileTimeInfo.wYear,FileTimeInfo.wMonth,FileTimeInfo.wDay,
              FileTimeInfo.wHour, FileTimeInfo.wMinute, FileTimeInfo.wSecond,
              FileTimeInfo.wMilliseconds,f.stats.atime);
    end;
  ucs4strdispose(ucs4str);
end;

function findfirstex(path: putf8char; attr: tresourceattributes; var SearchRec:TSearchRecExt): integer;
var
 lattr: longint;
 s: string;
 dir:dirstr;
 name: namestr;
 ext: extstr;
 ucs4str: pucs4char;
 ucs2str: pucs2char;
begin
  s:=strpas(path);
  SearchRec.stats.name:=strpas(path);
  SearchRec.stats.Attributes:=attr;
  lattr:=ExtAttrToWinAttr(attr);
  SearchRec.SearchAttr:=attr;
  SearchRec.IncludeAttr:=lAttr;
  s:=FExpand(s);
  Fsplit(s,dir,name,ext);
  if dir <> '' then
    begin
      if dir[Length(dir)] <> DirectorySeparator then
        dir:=dir+DirectorySeparator;
    end;
  SearchRec.stats.DirStr:=dir;
{ FindFirstFile is a Win32 Call }
  { Convert the string to a UCS-2 character string }
  { Expand wildcards }
  if path = '*' then
    path:='*.*';
  
  ucs4str:=ucs4strnew(path,'UTF-8');
  ucs2str:=ucs2strnew(ucs4str);
  SearchRec.FindHandle:=FindFirstFileW (pwidechar(ucs2str),SearchRec.W32FindData);
  ucs2strdispose(ucs2str);
  ucs4strdispose(ucs4str);
  If longint(SearchRec.FindHandle)=longint(Invalid_Handle_value) then
   begin
     FindFirstEx:=GetLastError;
     exit;
   end;
{ Find file with correct attribute }
  FindFirstEx:=FindMatch(SearchRec);
end;

function findnextex(var SearchRec: TSearchRecExt): integer;
begin
  if not FindNextFileW (SearchRec.FindHandle,SearchRec.W32FindData) then
   begin
     FindNextEx:=GetLastError;
     exit;
   end;
{ Find file with correct attribute }
  FindNextEx:=FindMatch(SearchRec);
end;

procedure findcloseex(var SearchRec: TSearchRecExt);
begin
  If longint(SearchRec.FindHandle)<>longint(Invalid_Handle_value) then
   begin
     if not Windows.FindClose(SearchRec.FindHandle) then
      begin
        exit;
      end;
   end;
end;


const

   CSIDL_APPDATA                 = $001A; { %USERPROFILE%\Application Data (roaming) }
     CSIDL_FLAG_CREATE             = $8000; { (force creation of requested folder if it doesn't exist yet)     }
     { Constants used with SHGetFolderPath routines }
    SHGFP_TYPE_CURRENT  = 0;   { current value for user, verify it exists }
    SHGFP_TYPE_DEFAULT  = 1;   { default value, may not exist }
     CSIDL_COMMON_APPDATA          = $0023; { %PROFILESPATH%\All Users\Application Data                        }
      CSIDL_PERSONAL                = $0005; { %USERPROFILE%\My Documents                                       }


{**********************************************************************}
{                         User configuration                           }
{**********************************************************************}

function SHGetFolderPathW(hwnd: HWND; csidl: Integer; hToken: THandle; dwFlags: DWord; pszPath: Pucs2Char): HRESULT; stdcall;
 external 'SHfolder.dll' name 'SHGetFolderPathW';


function GetLoginConfigDirectory: utf8string;
var
 PathValue: pucs2char;
 status: HRESULT;
 ucs4str: pucs4char;
begin
    GetLoginConfigDirectory:='';
    Getmem(PathValue,(MAX_PATH+1)*sizeof(ucs2char));
    status:=SHGetFolderPathW(0,CSIDL_APPDATA or CSIDL_FLAG_CREATE,0,SHGFP_TYPE_CURRENT,PathValue);
    if status = S_OK then
      begin
        { Convert to an UCS-4 character string, and then convert to
          an UTF-8 string. }
        ucs4str:=ucs4strnewucs2(PathValue);
        GetLoginConfigDirectory:=ucs4strpastoUTF8(ucs4str);
        ucs4strdispose(ucs4str);
      end;
    FreeMem(PathValue,(MAX_PATH+1)*sizeof(ucs2char));
end;    // *)

function GetGlobalConfigDirectory: utf8string;
var
 PathValue: pucs2char;
 status: HRESULT;
 ucs4str: pucs4char;
begin
    GetGlobalConfigDirectory:='';
    Getmem(PathValue,(MAX_PATH+1)*sizeof(ucs2char));
    status:=SHGetFolderPathW(0,CSIDL_COMMON_APPDATA or CSIDL_FLAG_CREATE,0,SHGFP_TYPE_CURRENT,PathValue);
    if status = S_OK then
      begin
        { Convert to an UCS-4 character string, and then convert to
          an UTF-8 string. }
        ucs4str:=ucs4strnewucs2(PathValue);
        GetGlobalConfigDirectory:=ucs4strpastoUTF8(ucs4str);
        ucs4strdispose(ucs4str);
      end;
    FreeMem(PathValue,(MAX_PATH+1)*sizeof(ucs2char));
end;


function GetLoginHomeDirectory: utf8string;
var
 PathValue: pucs2char;
 status: HRESULT;
 ucs4str: pucs4char;
begin
    GetLoginHomeDirectory:='';
    Getmem(PathValue,(MAX_PATH+1)*sizeof(ucs2char));
    status:=SHGetFolderPathW(0,CSIDL_PERSONAL or CSIDL_FLAG_CREATE,0,SHGFP_TYPE_CURRENT,PathValue);
    if status = S_OK then
      begin
        { Convert to an UCS-4 character string, and then convert to
          an UTF-8 string. }
        ucs4str:=ucs4strnewucs2(PathValue);
        GetLoginHomeDirectory:=ucs4strpastoUTF8(ucs4str);
        ucs4strdispose(ucs4str);
      end;
    FreeMem(PathValue,(MAX_PATH+1)*sizeof(ucs2char));
end;



 End.


{
  $Log: extdos.pas,v $
  Revision 1.8  2006/10/16 22:21:51  carl
  + extdos Initial Linux support

  Revision 1.7  2006/08/31 03:08:31  carl
  + Better documentation
  * Change case of some routines so they are consistent with other routines of this unit

  Revision 1.6  2006/01/21 22:32:18  carl
    + GetCurrentDirectory/SetCurrentDirectory

  Revision 1.5  2005/11/09 05:15:34  carl
    + DirectoryExists and FileExists added

  Revision 1.4  2005/07/20 03:13:25  carl
   + Documentation

  Revision 1.3  2004/12/26 23:31:34  carl
    * now empty skeleton, so it is portable

}
