{
 ****************************************************************************
    $Id: unicode.pas,v 1.46 2009/01/04 15:36:31 carl Exp $
    Copyright (c) 2004 by Carl Eric Codere

    Unicode related routines
    Partially converted from (the original code is missing some stuff!): 
    http://www.unicode.org/Public/PROGRAMS/CVTUTF/

    See License.txt for more information on the licensing terms
    for this source code.

 ****************************************************************************
}
{** @author(Carl Eric Codère)
    @abstract(unicode support unit)

    This unit contains routines to convert
    between the different unicode encoding
    schemes.

    All UNICODE/ISO 10646 pascal styled strings are limited to
    MAX_STRING_LENGTH characters. Null terminated unicode strings are
    limited by the compiler and integer type size.

    Since all these encoding are variable length, except the UCS-4 
    (which is equivalent to UTF-32 according to ISO 10646:2003) and UCS-2 
    encoding, to parse through characters, every string should be converted 
    to UCS-4 or UCS-2 before being used.

    The principal encoding scheme for this unit is UCS-4.
    
    Unicode tables are based on Unicode 4.1

}
{$T-}
{$X+}
{$Q-}

{$IFNDEF TP}
{$IFOPT H+}
{$DEFINE ANSISTRINGS}
{$ENDIF}
{$ENDIF}

{$IFDEF TP}
{$UNDEF ANSISTRINGS}
{$D-}
{$ENDIF}

unit unicode_x;

interface

uses 
  {tpautils,
  vpautils,
  dpautils,
  gpautils,
  fpautils,  }
  Xutils;

const
  {** Gives the number of characters that can be contained in a string }
  MAX_STRING_LENGTH = 2048; 

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
  
  {** UCS-2 string declaration. Index 0 contains the active length
      of the string in characters.
  }
  ucs2string = array[0..MAX_STRING_LENGTH] of ucs2char;
  {** UCS-4 string declaration. Index 0 contains the active length
      of the string in characters.
  }
  ucs4string = array[0..MAX_STRING_LENGTH] of ucs4char;

  {** UTF-8 string declaration. This can either map to 
      a short string or an ansi string depending on
      the compilation options.
  }
  utf8string = string;
  {** UTF-8 string pointer declaration. This is always
      a shortstring value.
  }
  putf8shortstring = ^shortstring;
  
  {** UTF-16 string declaration. Index 0 contains the active length
      of the string in BYTES
  }
  utf16string = array[0..MAX_STRING_LENGTH] of utf16char;

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

  {** Byte order mark: UTF-8 encoding signature }
  BOM_UTF8     = #$EF#$BB#$BF;
  {** Byte order mark: UCS-4 big endian encoding signature }
  BOM_UTF32_BE = #00#00#$FE#$FF;
  {** Byte order mark: UCS-4 little endian encoding signature }
  BOM_UTF32_LE = #$FF#$FE#00#00;
  
  BOM_UTF16_BE = #$FE#$FF;
  BOM_UTF16_LE = #$FF#$FE;
  
type
  ucs4strarray = array[0..MAX_UCS4_CHARS] of ucs4char;
  pucs4strarray = ^ucs4strarray;

  ucs2strarray = array[0..MAX_UCS2_CHARS] of ucs2char;
  pucs2strarray = ^ucs2strarray;


{---------------------------------------------------------------------------
                          UCS-4 string handling
-----------------------------------------------------------------------------}

  {** @abstract(Returns the current length of an UCS-4 string) }
  function ucs4_length(const s: array of ucs4char): integer;

  {** @abstract(Set the new dynamic length of an UCS-4 string) }
  procedure ucs4_setlength(var s: array of ucs4char; l: integer);

  {** @abstract(Determines if the specified character is a whitespace character) }
  function ucs4_iswhitespace(c: ucs4char): boolean;
  
  {** @abstract(Determines if the specified character is an hex-digit character) }
  function ucs4_ishexdigit(c: ucs4char): boolean;
  
  {** @abstract(Determines if the specified character is a digit character) 
      Represented by Unicode character class Decimal, Nd                     
  }
  function ucs4_isdigit(c: ucs4char): boolean;
  
  {** @abstract(Determines if the specified character is a sentence terminating character) }
  function ucs4_isterminal(c: ucs4char): boolean;
  
  {** @abstract(Converts a character to an uppercase character) 
  
      This routine only supports the simple form case folding
      algorithm (e.g full form is not supported).
  }
  function ucs4_upcase(c: ucs4char): ucs4char;

  {** @abstract(Converts a character to a lowercase character)

      This routine only supports the simple form case folding
      algorithm (e.g full form is not supported).

  }
  function ucs4_lowcase(c: ucs4char): ucs4char;

  {** @abstract(Trims leading spaces and control characters from an UCS-4 string.) }
  procedure ucs4_trimleft(var s: ucs4string);
  
  {** @abstract(Trims trailing spaces and control characters from an UCS-4 string.) }
  procedure ucs4_trimright(var s: ucs4string);

  {** @abstract(Trims trailing and leading spaces and control characters from an UCS-4 string.) }
  procedure ucs4_trim(var s: ucs4string);

  {** @abstract(Returns an UCS-4 substring of an UCS-4 string) }
  procedure ucs4_copy(var resultstr: ucs4string; const s: ucs4string; index: integer; count: integer);

  {** @abstract(Deletes a substring from a string) }
  procedure ucs4_delete(var s: ucs4string; index: integer; count: integer);

  {** @abstract(Concatenates two UCS-4 strings, and gives a resulting UCS-4 string) }
  procedure ucs4_concat(var resultstr: ucs4string;const s1: ucs4string; const s2: array of ucs4char);
  
  {** @abstract(Returns the base string representation of a canonical string).
      This routine is useful for converted multilangual strings to their ASCII
      equivalents. It removes all accented characters and replaces them with
      their base equivalent.
  }
  procedure ucs4_removeaccents(var resultstr: ucs4string;s2: ucs4string);

  
  {** @abstract(Returns the base character representation of a canonical character).
      This routine is useful for converted multilangual strings to their ASCII
      equivalents. It converts an accented characters and replaces them with
      the base equivalent or returns the input character if there is no 
      base equivalent.
  }
  function ucs4_getbasechar(c: ucs4char): ucs4char;
  

  {** @abstract(Concatenates an UCS-4 string with an ASCII string, and gives
      a resulting UCS-4 string)
  }    
  procedure ucs4_concatascii(var resultstr: ucs4string;const s1: ucs4string; const s2: string);

  {** @abstract(Searches for an ASCII substring in an UCS-4 string) }
  function ucs4_posascii(const substr: string; const s: ucs4string): integer;

  {** @abstract(Checks if an ASCII string is equal to an UCS-4 string ) }
  function ucs4_equalascii(const s1 : array of ucs4char; s2: string): boolean;

  {** @abstract(Searches for an UCS-4 substring in an UCS-4 string) }
  function ucs4_pos(const substr: ucs4string; const s: ucs4string): integer;

  {** @abstract(Checks if both UCS-4 strings are equal) }
  function ucs4_equal(const s1,s2: ucs4string): boolean;
  
  {** @abstract(Retrieves the Unicode numeric value of a character) 
  
      Returns the numeric value of a character that can be used
      to represent a number.
      
      If a character does not have a numeric value, the routine
      returns -1. If a character cannot be represented as a 
      positive integer (such as fractional characters), -2
      is returned.
  }
  function ucs4_getNumericValue(c: ucs4char): longint;
  
  

  {** @abstract(Checks if the UCS-4 character is valid)

      This routine verifies if the UCS-4 character is
      within the valid ranges of UCS-4 characters, as
      specified in the Unicode standard 4.0. BOM characters
      are NOT valid with this routine.
  }
  function ucs4_isvalid(c: ucs4char): boolean;

  {** @abstract(Checks if conversion from/to this character set format to/from UCS-4
      is supported)

      @param(s This is an alias for a character set, as defined by IANA)
      @returns(true if conversion to/from UCS-4 is supported with this
        character set, otherwise FALSE)
  }
  function ucs4_issupported(s: string): boolean;
  
  {** @abstract(Converts an UCS-4 string to an ISO-8859-1 string)

      @param(s The UCS-4 string to convert)
      @returns(The converted string with possible escape characters
        if a character could not be converted)
  }
    function ucs4_converttoiso8859_1(const s: ucs4string): string;

  {** @abstract(Converts an UCS-4 string to an UTF-8 string)

     If there is an error (such as reserved special
     characters), returns an empty string

      @param(s The UCS-4 string to convert)
      @returns(The converted string)
  }
  function ucs4_converttoutf8(const src: ucs4string): utf8string;

  

{---------------------------------------------------------------------------
                  UCS-4 null terminated string handling
-----------------------------------------------------------------------------}



  {** @abstract(Returns the number of characters in the null terminated UCS-4 string)

      @param(str The UCS-4 null terminated string to check)
      @returns(The number of characters in str, not counting the null
        character)
  }
  function ucs4strlen(str: pucs4char): integer;

  {** @abstract(Converts a null-terminated UCS-4 string to a Pascal-style UCS-4 string.)
  }
 procedure ucs4strpas(str: pucs4char; var res:ucs4string);
 
  {** @abstract(Converts a null-terminated UCS-4 string to a Pascal-style 
       ISO 8859-1 encoded string.)
       
      If the length is greater than the supported maximum string
      length, the string is truncated.
       
       
      Characters that cannot be converted are converted to 
      escape sequences of the form : \uxxxxxxxx where xxxxxxxx is
      the hex representation of the character.
  }
 function ucs4strpastoISO8859_1(str: pucs4char): string;
 
  {** @abstract(Converts a null-terminated UCS-4 string to a Pascal-style 
       ASCII encoded string.)
       
       If the length is greater than the supported maximum string
       length, the string is truncated.
       

      Characters that cannot be converted are converted to
      escape sequences of the form : \uxxxxxxxx where xxxxxxxx is
      the hex representation of the character.
  }
 function ucs4strpastoASCII(str: pucs4char): string;
 
  {** @abstract(Converts a null-terminated UCS-4 string to a Pascal-style 
       UTF-8 encoded string.)
       
       If the length is greater than the supported maximum string
       length, the string is truncated.

  }
 function ucs4strpastoUTF8(str: pucs4char): utf8string;
 

  {** @abstract(Copies a Pascal-style UCS-4 string to a null-terminated UCS-4 string.)

      This routine does not perform any length checking.
      If the source string contains some null characters,
      those nulls are removed from the resulting string.

      The destination buffer must have room for at least Length(Source)+1 characters.
  }
 function ucs4strpcopy(dest: pucs4char; source: ucs4string):pucs4char;


  {** @abstract(Converts a pascal string to an UCS-4 null
   terminated string)

   The memory for the buffer is allocated. Use @link(ucs4strdispose) to dispose
   of the allocated string. The string is null terminated. If the original
   string contains some null characters, those nulls are removed from
   the resulting string. 

   @param(str The string to convert, single character coded)
   @param(srctype The encoding of the string, UTF-8 is also valid - case-insensitive)
  }
 function ucs4strnewstr(str: string; srctype: string): pucs4char;

  {** @abstract(Converts a null terminated string to an UCS-4 null
   terminated string)

   The memory for the buffer is allocated. Use @link(ucs4strdispose) to dispose
   of the allocated string. The string is null terminated. If str is nil, then
   this routine returns nil and does not allocate anything.

   @param(str The string to convert, single character coded, or UTF-8 coded)
   @param(srctype The encoding of the string, UTF-8 is also valid - case-insensitive)
  }
 function ucs4strnew(str: pchar; srctype: string): pucs4char;

  {** @abstract(Allocates and copies an UCS-4 null terminated string)

   The memory for the buffer is allocated. Use @link(ucs4strdispose) to dispose
   of the allocated string. The string is copied from src and is null terminated.
   If the parameter is nil, this routine returns nil and does not allocate
   anything.
  }
  function ucs4strnewucs4(src: pucs4char): pucs4char;


  {** @abstract(Converts an UCS-2 null terminated string to an UCS-4 null
   terminated string)

   The memory for the buffer is allocated. Use @link(ucs4strdispose) to dispose
   of the allocated string. The string is null terminated. If str is nil, then
   this routine returns nil and does not allocate anything.

   @param(str The string to convert, UCS-2 encoded)
  }
 function ucs4strnewucs2(str: pucs2char): pucs4char;


  {** @abstract(Disposes of an UCS-4 null terminated string on the heap)

      Disposes of a string that was previously allocated with
      @code(ucs4strnew), and sets the pointer to nil.

  }
 function ucs4strdispose(str: pucs4char): pucs4char;

 {** Returns a pointer to the first occurence of an ISO-8859-1
     encoded null terminated string in a UCS-4 encoded
     null terminated string.

 }
 function ucs4strposISO8859_1(S: pucs4char; Str2: PChar): pucs4char;

 {** @abstract(Allocate and copy trimmed an UCS-4 null terminated string)
     
     Allocates a new UCS-4 null terminated string, and copies
     the existing string, avoiding a copy of the whitespace at
     the start and end of the string
 }
 function ucs4strtrim(const p: pucs4char): pucs4char;

 {** @abstract(Fills an UCS-4 null terminated string with the specified UCS-4 character)
     
     Fills a memory region consisting of ucs-4 characters
     with the specified UCS-4 character.
 }
 function ucs4strfill(var p: pucs4char; count: integer; value: ucs4char): pucs4char;


  {** This routine checks the validity of an UCS-4 null terminated string.
      It first skips to the null character, and if maxcount is greater than
      the index, verifies that the values in memory are of value VALUE.

      Otherwise, returns an ERROR. This routine is used with ucs4strfill.
  }
  procedure ucs4strcheck(p: pucs4char; maxcount: integer; value: ucs4char);




{---------------------------------------------------------------------------
                           UCS-2 string handling
-----------------------------------------------------------------------------}

  {** @abstract(Returns the current length of an UCS-2 string) }
  function ucs2_length(const s: array of ucs2char): integer;

  {** @abstract(Set the new dynamic length of an ucs-2 string) }
  procedure ucs2_setlength(var s: array of ucs2char; l: integer);

  {** @abstract(Checks if the UCS-2 character is valid)

      This routine verifies if the UCS-2 character is
      within the valid ranges of UCS-2 characters, as
      specified in the Unicode standard 4.0. BOM characters
      are NOT valid with this routine.
  }
  function ucs2_isvalid(ch: ucs2char): boolean;
  
  {** @abstract(Converts a character to an uppercase character) 
  
      This routine only supports the simple form case folding
      algorithm (e.g full form is not supported).
  }
  function ucs2_upcase(c: ucs2char): ucs2char;
  

{---------------------------------------------------------------------------
                   UCS-2 null terminated string handling
-----------------------------------------------------------------------------}

  {** @abstract(Convert an UCS-2 null terminated string to an UCS-4 null terminated string)

      This routine converts an UCS-2 encoded null terminared string to an UCS-4
      null terminated string that is stored in native byte order, up to
      length conversion. The destination buffer should already have been
      allocated.

      @returns(nil if there was an error in the conversion)
  }
  function ucs2strlcopyucs4(src: pucs2char; dst: pucs4char; maxlen: integer): pucs4char;


  {** @abstract(Returns the number of characters in the null terminated UCS-2 string)

      @param(str The UCS-2 null terminated string to check)
      @returns(The number of characters in str, not counting the null
        character)
  }
  function ucs2strlen(str: pucs2char): integer;



  {** @abstract(Converts an UCS-4 null terminated string to an UCS-2 null
   terminated string)

   The memory for the buffer is allocated. Use @link(ucs2strdispose) to dispose
   of the allocated string. The string is null terminated. If src is nil,
   this routine returns nil, and does not allocate anything.

   @returns(nil if the conversion cannot be represented in UCS-2 encoding,
      or nil if there was an error)
  }
  function ucs2strnew(src: pucs4char): pucs2char;

  {** @abstract(Disposes of an UCS-2 null terminated string on the heap)

      Disposes of a string that was previously allocated with
      @code(ucs2strnew), and sets the pointer to nil.

  }
  function ucs2strdispose(str: pucs2char): pucs2char;

{---------------------------------------------------------------------------
                  UTF-8 null terminated string handling
-----------------------------------------------------------------------------}

  {** @abstract(Converts an UCS-4 null terminated string to an UTF-8 null
   terminated string)

   The memory for the buffer is allocated. Use @link(utf8strdispose) to dispose
   of the allocated string. The string is null terminated. If the parameter is
   nil, this routine returns nil and does not allocate anything.
  }
  function utf8strnew(src: pucs4char): pchar;
  
  
  {** @abstract(Returns the length of the string, not counting the
   null character)
   
   If the pointer is nil, the value returned is zero.
  }
  function utf8strlen(s: putf8char): integer;
  

  {** @abstract(Allocates and copies an UTF-8 null terminated string)

   The memory for the buffer is allocated. Use @link(utf8strdispose) to dispose
   of the allocated string. The string is copied from src and is null terminated.
   If the parameter is nil, this routine returns nil and does not allocate
   anything.
  }
  function utf8strnewutf8(src: pchar): pchar;


  {** @abstract(Disposes of an UTF-8 null terminated string on the heap)

      Disposes of a string that was previously allocated with
      @code(utf8strnew), and sets the pointer to nil.

  }
  function utf8strdispose(p: pchar): pchar;
  
  
  {** @abstract(Validates the legality of an UTF-8 null terminated string)

      Verifies that the UTF-8 encoded strings is encoded in a legal
      way.

      @returns(FALSE if the string is illegal, otherwise returns TRUE)

  }
  function utf8islegal(p: pchar): boolean;
  


  {** @abstract(Convert an UTF-8 null terminated string to an UCS-4 null terminated string)

      This routine converts an UTF-8 null terminared string to an UCS-4
      null terminated string that is stored in native byte order, up to
      length conversion.

      @returns(nil if there was no error in the conversion)
  }
  function utf8strlcopyucs4(src: pchar; dst: pucs4char; maxlen: integer): pucs4char;

  {** @abstract(Converts a null-terminated UTF-8 string to a Pascal-style
       ISO 8859-1 encoded string.)

      Characters that cannot be converted are converted to
      escape sequences of the form : \uxxxxxxxx where xxxxxxxx is
      the hex representation of the character.
  }
 function utf8strpastoISO8859_1(src: pchar): string;

  {** @abstract(Converts a null-terminated UTF-8 string to a Pascal-style
       ASCII encoded string.)

      Characters that cannot be converted are converted to
      escape sequences of the form : \uxxxxxxxx where xxxxxxxx is
      the hex representation of the character.
  }
 function utf8strpastoASCII(src: pchar): string;
 
  {** @abstract(Converts an UTF-8 null terminated string to a string 
      encoded to a different code page)

      Characters that cannot be converted are converted to
      escape sequences of the form : \uxxxxxxxx where xxxxxxxx is
      the hex representation of the character.
      
      If the null character string does not fit in the
      resulting string, it is truncated.
      
      @param(src Null terminated UTF-8 encoded string)
      @param(desttype Encoding type for resulting string)
      @returns(an empty string on error, or a correctly encoded
         string).
  }
 function utf8strpastostring(src: pchar; desttype: string): string;
 

  {** @abstract(Converts a null-terminated UTF-8 string to a Pascal-style
       UTF-8 encoded string.)
       
       The string is empty if the pointer was nil.

  }
 function utf8strpas(src: pchar): string;
 
 
  {** @abstract(Converts an UTF-8 string to a null terminated UTF-8 string.)
  
      The memory for the storage of the string is allocated by
      the routine, and the ending null character is also added.
      
      @returns(The newly allocated UTF-8 null terminated string)

  }
 function utf8strnewstr(str: utf8string): putf8char;

{---------------------------------------------------------------------------
                           UTF-8 string handling
-----------------------------------------------------------------------------}
 
  {** @abstract(Frees an UTF-8 string that was allocated
       with @link(utf8strdispose))
       
      Verifies if the pointer is different than nil before
      freeing it.
  }      
  procedure utf8stringdispose(var p : putf8shortstring);


  
  {** @abstract(Allocates and copies an UTF-8 string to a pointer 
        to an UTF-8 string).
        
      Even if the length of the string is of zero bytes, the
      string will still be allocated and returned.
  }        
  function utf8stringdup(const s : string) : putf8shortstring;
  
  {** @abstract(Returns the number of characters that are used to encode this
      character)

  }
  function utf8_sizeencoding(c: utf8char): integer;

  {** @abstract(Returns the current length of an UTF-16 string) }
  function utf16_length(const s: array of utf16char): integer;

  {** @abstract(Returns the current length of an UTF-8 string) }
  function utf8_length(const s: utf8string): integer;

  {** @abstract(Returns if the specified UTF-8 string is legal or not)

      Verifies that the UTF-8 encoded strings is encoded in a legal
      way.

      @returns(FALSE if the string is illegal, otherwise returns TRUE)
  }
  function utf8_islegal(const s: utf8string): boolean;

  {** @abstract(Set the length of an UTF-8 string) }
  procedure utf8_setlength(var s: utf8string; l: integer);
  

{---------------------------------------------------------------------------
                          Other  string handling
-----------------------------------------------------------------------------}


  {** @abstract(Converts a null-terminated ASCII string to a Pascal-style
       ASCII encoded string.)
       
       The returned string shall be empty if the pointer was nil.

  }
 function asciistrpas(src: pchar): string;
 
 {** @abstract(Allocates and copies an ascii null-terminated string
      from a null-terminated string)
      
     The value returned is nil, if the src pointer was also nil. 
      
 }
 function asciistrnew(src: pchar): pchar;
  
 {** @abstract(Allocates and copies an ascii  string
      to a null-terminated string)
      
     The value returned is nil, if the length of str = 0.
      
 }
 function asciistrnewstr(const str: string): pchar;
 
  {** @abstract(Converts a null-terminated ISO-8859-1 string to a Pascal-style
       ASCII encoded string.)
       
       The returned string shall be empty if the pointer was nil.

  }
 function ansistrpas(src: pchar): string;
 
 {** @abstract(Allocates and copies an ISO-8859-1 null-terminated string
      from a null-terminated string)
      
     The value returned is nil, if the src pointer was also nil. 
      
 }
 function ansistrnew(src: pchar): pchar;
  
 {** @abstract(Allocates and copies an ansi string
      to a null-terminated string)
      
     The value returned is nil, if the length of str = 0.
      
 }
 function ansistrnewstr(const str: string): pchar;

 {** @abstract(Disposes of an ansi null-terminated string)
      
     Does nothing if the pointer passed is already nil.
      
 }
 function ansistrdispose(p: pchar): pchar;


  {** @abstract(Returns the number of characters that are used to encode this
      character)

      Actually checks if this is a high-surrogate value, if not returns 1,
      indicating that the character is encoded a single @code(utf16) character,
      otherwise returns 2, indicating that 1 one other @code(utf16) character
      is required to encode this data.
  }
  function utf16_sizeencoding(c: utf16char): integer;


  {** @abstract(Set the length of an UTF-16 string) }
  procedure utf16_setlength(var s: array of utf16char; l: integer);


{---------------------------------------------------------------------------
                      Unicode Conversion routines
-----------------------------------------------------------------------------}


  {** @abstract(Convert an UCS-4 string to an UTF-8 string)

      Converts an UCS-4 string or character
      in native endian to an UTF-8 string.

      @param(s Either a single UCS-4 character or a complete UCS-4 string)
      @param(outstr Resulting UTF-8 coded string)
      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)
  }
  function convertUCS4toUTF8(s: array of ucs4char; var outstr: utf8string): integer;

  {** @abstract(Convert an UCS-4 string to a single byte encoded string)

     This routine converts an UCS-4 string stored in native byte order
     (native endian) to a single-byte encoded string.

     The string is limited to MAX_STRING_LENGTH characters, and if
     the conversion cannot be successfully be completed, it gives out an error.

     The following @code(desttype) can be specified: ISO-8859-1, windows-1252,
     ISO-8859-2, ISO-8859-5, ISO-8859-16, macintosh, atari, cp437, cp850, ASCII
     and UTF-8.

      @param(desttype Indicates the single byte encoding scheme - case-insensitive)
      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)
  }
  function ConvertFromUCS4(const source: ucs4string; var dest: string; desttype: string): integer;

  {** @abstract(Convert a byte encoded string to an UCS-4 string)

     This routine converts a single byte encoded string to an UCS-4
     string stored in native byte order

     Characters that cannot be converted are converted to escape
     sequences of the form : \uxxxxxxxx where xxxxxxxx is the hex
     representation of the character, an error code will also be
     returned by the function

     The string is limited to MAX_STRING_LENGTH characters, and if
     the conversion cannot be successfully be completed, it gives
     out an error. The following @code(srctype) can be specified:
     ISO-8859-1, windows-1252, ISO-8859-2, ISO-8859-5, ISO-8859-16,
     macintosh, atari, cp437, cp850, ASCII.

      @param(srctype Indicates the single byte encoding scheme - case-insensitive)
      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)
  }
  function ConvertToUCS4(source: string; var dest: ucs4string; srctype: string): integer;

  {** @abstract(Convert an UTF-16 string to an UCS-4 string)

      This routine converts an UTF-16 string to an UCS-4 string.
      Both strings must be stored in native byte order (native endian).

      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)
  }
  function ConvertUTF16ToUCS4(src: utf16string; var dst: ucs4string): integer;

  {** @abstract(Convert an UCS-4 string to an UTF-16 string)

      This routine converts an UCS-4 string to an UTF-16 string.
      Both strings must be stored in native byte order (native endian).

      @param(src Either a single UCS-4 character or a complete UCS-4 string)
      @param(dest Resulting UTF-16 coded string)
      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)
  }
  function ConvertUCS4toUTF16(src: array of ucs4char; var dest: utf16string): integer;

  {** @abstract(Convert an UTF-8 string to an UCS-4 string)

      This routine converts an UTF-8 string to an UCS-4 string that
      is stored in native byte order.

      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)
  }
  function ConvertUTF8ToUCS4(src: utf8string; var dst: ucs4string): integer;

  {** @abstract(Convert an UCS-4 string to an UCS-2 string)

      This routine converts an UCS-4 string to an UCS-2 string that
      is stored in native byte order. If some characters
      could not be converted an error will be reported.

      @param(src Either a single UCS-4 character or a complete UCS-4 string)
      @param(dest Resulting UCS-2 coded string)
      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)

  }
  function ConvertUCS4ToUCS2(src: array of ucs4char; var dst: ucs2string): integer;


  {** @abstract(Convert an UCS-2 string to an UCS-4 string)

      This routine converts an UCS-2 string to an UCS-4 string that
      is stored in native byte order (big-endian). If some characters
      could not be converted an error will be reported.

      @param(src Either a single ucs-2 character or a complete ucs-2 string)
      @param(dest Resulting UCS-4 coded string)
      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)

  }
  function ConvertUCS2ToUCS4(src: array of ucs2char; var dst: ucs4string): integer;



{ Case conversion table }
{$i case.inc}
{ Digits }
{$i digits.inc}
{ Hex Digits }
{$i hexdig.inc}
{ Whitespace }
{$i whitespc.inc}
{ Terminals }
{$i term.inc}
{ Numeric values of characters }
{$i numeric.inc}

implementation

uses strings;


type
  pchararray = ^tchararray;
  tchararray = array[#0..#255] of ucs2char;
  taliasinfo = record
    aliasname: string[32];
    table: pchararray;
  end;
  

{ Accented character conversion table }
{$i canonic.inc}

type  
  tcanonicalmappings =  array[1..MAX_CANONICAL_MAPPINGS] of TCanonicalInfo;
  pcanonicalmappings = ^tcanonicalmappings;
  
var
  { Pointer to the canonical mapping table, had to do it, because in
    TP it took too much space }
  CanonicalMap: pcanonicalmappings;
  ExitSave: pointer;
{$ifdef tp}    
  p: pchar;
{$endif}



const
  {** We use the Private User Area to indicate a unmapped code point }
  UNKNOWN_CODEPOINT = $E000;
  
{$i i8859_1.inc}
{$i i8859_2.inc}
{$i i8859_5.inc}
{$i i8859_16.inc}
{$i atarist.inc}
{$i cp1252.inc}
{$i cp437.inc}
{$i cp850.inc}
{$i macroman.inc}

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



const
  MAX_ALIAS = 26;

const
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



{*
 * Once the bits are split out into bytes of UTF-8, this is a mask OR-ed
 * into the first byte, depending on how many bytes follow.  There are
 * as many entries in this table as there are UTF-8 sequence types.
 * (I.e., one byte sequence, two byte... six byte sequence.)
 *}
 const firstByteMark: array[0..6] of utf8char =
 (
   #$00, #$00, #$C0, #$E0, #$F0, #$F8, #$FC
 );

  const
    byteMask: ucs4char = $BF;
    byteMark: ucs4char = $80;

    
  function convertUCS4toUTF8(s: array of ucs4char; var outstr: utf8string): integer;
  var
   i: integer;
   ch: ucs4char;
   bytesToWrite: integer;
   OutStringLength : integer;
   OutIndex : integer;
   Currentindex: integer;
   StartIndex: integer;
   EndIndex: integer;
  begin
    ConvertUCS4ToUTF8:=UNICODE_ERR_OK;
    OutIndex := 1;
    OutStringLength := 0;
    { Check if only one character is passed as src, in that case
      this is not an UTF string, but a simple character (in other
      words, there is not a length byte.
    }
    if High(s) = 0 then
      begin
        StartIndex:=0;
        EndIndex:=0;
        { Put it a safe value, this is present because it can be
          an AnsiString }
        utf8_setlength(outstr,sizeof(ucs4char));
      end
    else
      begin
        StartIndex:=1;
        EndIndex:=UCS4_Length(s);
        { Put it a safe value, this is present because it can be
          an AnsiString }
        utf8_setlength(outstr,endindex*sizeof(ucs4char));
      end;

    for i:=StartIndex to EndIndex do
     begin
       ch:=s[i];    

       if (ch > UNI_MAX_UTF16) then
       begin
         convertUCS4ToUTF8:= UNICODE_ERR_SOURCEILLEGAL;
         exit;
       end;
     
     
       if ((ch >= UNI_SUR_HIGH_START) and (ch <= UNI_SUR_LOW_END)) then
       begin
         convertUCS4ToUTF8:= UNICODE_ERR_SOURCEILLEGAL;
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
      if Outindex > High(utf8string) then
        begin
          convertUCS4ToUTF8:=UNICODE_ERR_LENGTH_EXCEED;
          utf8_setlength(outstr,0);
          exit;
        end;
{$ENDIF}        
        CurrentIndex := BytesToWrite;
        if CurrentIndex = 4 then
        begin
          dec(OutIndex);
          outstr[outindex] := utf8char((ch or byteMark) and ByteMask);
          ch:=ch shr 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 3 then
        begin
          dec(OutIndex);
          outstr[outindex] := utf8char((ch or byteMark) and ByteMask);
          ch:=ch shr 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 2 then
        begin
          dec(OutIndex);
          outstr[outindex] := utf8char((ch or byteMark) and ByteMask);
          ch:=ch shr 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 1 then
        begin
          dec(OutIndex);
          outstr[outindex] := utf8char((byte(ch) or byte(FirstbyteMark[BytesToWrite])));
        end;  
        inc(OutStringLength,BytesToWrite);
        Inc(OutIndex,BytesToWrite);
      end;      
      utf8_setlength(outstr,OutStringLength);
  end;
  
  function utf16_length(const s: array of utf16char): integer;
  begin
   utf16_length:=integer(s[0]);
  end;

  function utf8_length(const s: utf8string): integer;
  begin
   utf8_length:=length(s);
  end;
  

  

  procedure utf8_setlength(var s: utf8string; l: integer);
  begin
    setlength(s,l);
  end;

  procedure utf16_setlength(var s: array of utf16char; l: integer);
  begin
   s[0]:=utf16char(l);
  end;
  
  
  function utf8islegal(p: pchar): boolean;
  var morebytes: integer;
      i,j: integer;
      len: integer;
  begin
    utf8islegal:=false;
    len:=utf8strlen(p);
    i:=0;
    while i <= len do
    begin
        morebytes:=trailingBytesForUTF8[ord(p[i])];
        inc(i);
        if morebytes <> 0 then
        begin
           for j:=i to (i+morebytes-1) do
             begin
              if j > len then exit;
              if ((ord(p[j]) and $C0) <> $80) then
                 exit;
             end;
        end;
        inc(i,morebytes);
    end;
    utf8islegal:=true;
  end;

  function utf8_islegal(const s: utf8string): boolean;
  var morebytes: integer;
      i,j: integer;
  begin
    utf8_islegal:=false;
    i:=1;
    while i <= utf8_length(s) do
    begin
        morebytes:=trailingBytesForUTF8[ord(s[i])];
        inc(i);
        if morebytes <> 0 then
        begin
           for j:=i to (i+morebytes-1) do
             begin
              if j > length(s) then exit;
              if ((ord(s[j]) and $C0) <> $80) then
                 exit;
             end;
        end;
        inc(i,morebytes);
    end;
    utf8_islegal:=true;
  end;
    
  

  
  function ConvertFromUCS4(const source: ucs4string; var dest: string; desttype: string): integer;
  var
   i: integer;
   j: char;
   p: pchararray;
   found: boolean;
   sourcelength: integer;
  begin
    dest:='';
    ConvertFromUCS4:=UNICODE_ERR_OK;  
    p:=nil;
    desttype:=upstring(desttype);
    if desttype = 'UTF-8' then
      begin
        ConvertFromUCS4:=convertUCS4toUTF8(source,dest);
        exit;
      end;
    for i:=1 to MAX_ALIAS do
      begin
        if aliaslist[i].aliasname = desttype then
         begin
           p:=aliaslist[i].table;
           break;
         end;
      end;
    if not assigned(p) then
     begin
       ConvertFromUCS4:=UNICODE_ERR_NOTFOUND;  
       exit;
     end;
    { for each character in the UCS-4 string ... }  
    sourcelength:=ucs4_length(source);
    { Check if this is an ISO-8859-1 conversion }
    if (pointer(p) = @i8859_1toUTF32) then
      begin
          for i:=1 to sourcelength do
            begin
              if (source[i] > ucs4char(high(char))) then
                begin
                 dest:=dest+'\u'+hexstr(longint(source[i]),8);
                 ConvertFromUCS4:=UNICODE_ERR_INCOMPLETE_CONVERSION;
                 continue;
                end;
              dest:=dest+char(source[i]);
            end;
         exit;                    
      end;
    for i:=1 to sourcelength do
      begin
         found:=false;
         { search the table by reverse lookup }
         for j:=#0 to high(char) do 
          begin     
            if ucs4char(source[i]) = ucs4char(p^[j]) then
              begin
               dest:=dest+j;
               found:=true;
               break;
              end;
          end;
         if not found then
          begin
            dest:=dest+'\u'+hexstr(longint(source[i]),8);
            ConvertFromUCS4:=UNICODE_ERR_INCOMPLETE_CONVERSION;
          end;
      end;
  end;
  
  function ConvertToUCS4(source: string; var dest: ucs4string; srctype: string): integer;
  var
   i: integer;
   l: longint;
   p: pchararray;
   currentindex: integer;
   strlength: integer;
  begin
    ConvertToUCS4:=UNICODE_ERR_OK;
    source:=removenulls(source);
    srctype:=upstring(srctype);
    p:=nil;
    { Check if we have a null length, then set the length and exit }
    if length(source) = 0 then
      begin
        ucs4_setlength(dest,0);
        exit;
      end;
    if srctype = 'UTF-8' then
      begin
        ConvertToUCS4:=convertUTF8toUCS4(source,dest);
        exit;
      end;
    { Search the alias type }
    for i:=1 to MAX_ALIAS do
      begin
        if aliaslist[i].aliasname = srctype then
          begin
            p:=aliaslist[i].table;
            break;
          end;
      end;
    if not assigned(p) then
      begin
        ConvertToUCS4:=UNICODE_ERR_NOTFOUND;  
        exit;
      end;
    currentindex:=1;
    strlength:=length(source);
    for i:=1 to strlength do
      begin
        l:=p^[source[i]];
        if l = UNKNOWN_CODEPOINT then
          begin
            ConvertToUCS4:=UNICODE_ERR_INCOMPLETE_CONVERSION;
            continue;
          end;
        dest[currentindex]:=ucs4char(l);  
        inc(currentindex);
      end;
    { The count is always one more }  
    UCS4_setlength(dest,currentindex-1);
  end;


  function ConvertUTF16ToUCS4(src: utf16string; var dst: ucs4string): integer;
   var
     ch,ch2: ucs4char;
     i: integer;
     Outindex: integer;
  begin
    i:=1;
    Outindex := 1;
    ConvertUTF16ToUCS4:=UNICODE_ERR_OK;
    while i <= utf16_length(src) do
      begin
        ch:=ucs4char(src[i]);
        inc(i);
        if (ch >= UNI_SUR_HIGH_START) and (ch <= UNI_SUR_HIGH_END) and (i < utf16_length(src)) then
          begin
              ch2:=src[i];
              if (ch2 >= UNI_SUR_LOW_START) and (ch2 <= UNI_SUR_LOW_END) then
                begin
                  ch := ((ch - UNI_SUR_HIGH_START) shl halfShift)
                          + (ch2 - UNI_SUR_LOW_START) + halfBase;
                end
             else
                begin
                  ConvertUTF16ToUCS4 := UNICODE_ERR_SOURCEILLEGAL;
                  exit;
                end;
          end
        else
        if (ch >= UNI_SUR_LOW_START) and (ch <= UNI_SUR_LOW_END) then
          begin
            ConvertUTF16ToUCS4 := UNICODE_ERR_SOURCEILLEGAL;
            exit;
          end;
        dst[OutIndex] := ch;
        Inc(OutIndex);
     end;     
  ucs4_setlength(dst,OutIndex-1);
end;

function ConvertUTF8ToUCS4(src: utf8string; var dst: ucs4string): integer;
  var
   ch: ucs4char;
   i: integer;
   StringLength: integer;
   Outindex: integer;
   ExtraBytesToRead: integer;
   idx: integer;
   strlength: integer;
  begin
    i:=1;
    stringlength := 0;
    OutIndex := 1;
    ConvertUTF8ToUCS4:=UNICODE_ERR_OK;
    strlength:=utf8_length(src);
    while i <= strlength do
      begin
        ch := 0;
        extrabytestoread:= trailingBytesForUTF8[ord(src[i])];
        if (stringlength + extraBytesToRead) >= high(ucs4string) then
          begin
            ConvertUTF8ToUCS4:=UNICODE_ERR_LENGTH_EXCEED;
            exit;
          end;
{        if not isLegalUTF8(src, extraBytesToRead+1) then
          begin
            ConvertUTF8ToUCS4:=UNICODE_ERR_SOURCEILLEGAL;
            exit;
          end;}
        for idx:=ExtraBytesToRead downto 1 do
          begin
            ch:=ch + ucs4char(src[i]);
            inc(i);
            ch:=ch shl 6;
          end;
        ch:=ch + ucs4char(src[i]);
        inc(i);
        ch := ch - offsetsFromUTF8[extraBytesToRead];
        if (ch <= UNI_MAX_UTF32) then
          begin
            dst[OutIndex] := ch;
            inc(OutIndex);
          end
        else
          begin
            dst[OutIndex] := UNI_REPLACEMENT_CHAR;
            inc(OutIndex);
          end;
      end;
     ucs4_setlength(dst, outindex-1);
  end;
  

function ConvertUCS4toUTF16(src: array of ucs4char; var dest: utf16string): integer;
var
 ch: ucs4char;
   i: integer;
   Outindex: integer;
   StartIndex, EndIndex: integer;
begin
    OutIndex := 1;
    ConvertUCS4ToUTF16:=UNICODE_ERR_OK;
    { Check if only one character is passed as src, in that case
      this is not an UTF string, but a simple character (in other
      words, there is not a length byte.
    }
    if High(src) = 0 then
      begin
        StartIndex:=0;
        EndIndex:=0;
      end
    else
      begin
        StartIndex:=1;
        EndIndex:=UCS4_Length(src);
      end;
    
    i:=Startindex;
    while i <= EndIndex do
      begin
        ch:=src[i];
        inc(i);
        {* Target is a character <= 0xFFFF *}
        if (ch <= UNI_MAX_BMP) then
          begin
            if (ch >= UNI_SUR_HIGH_START) and (ch <= UNI_SUR_LOW_END) then
              begin
                ConvertUCS4ToUTF16:=UNICODE_ERR_SOURCEILLEGAL;
                exit;
              end
            else
              begin
                dest[OutIndex] := utf16char(ch);
                inc(OutIndex);
              end;
          end
        else 
        if (ch > UNI_MAX_UTF16) then
          begin
            ConvertUCS4ToUTF16:=UNICODE_ERR_SOURCEILLEGAL;
            exit;
          end
        else
          begin
            if OutIndex + 1> High(utf16string) then
              begin
                ConvertUCS4ToUTF16:=UNICODE_ERR_LENGTH_EXCEED;
                exit;
              end;
            ch := ch - Halfbase;
            dest[OutIndex] := (ch shr halfShift) + UNI_SUR_HIGH_START;
            inc(OutIndex);
            dest[OutIndex] := (ch and halfMask) + UNI_SUR_LOW_START;
            inc(OutIndex);
          end;
      end;
    utf16_setlength(dest, OutIndex);  
end;


  function ConvertUCS4ToUCS2(src: array of ucs4char; var dst: ucs2string): integer;
  var
   ch: ucs4char;
   i: integer;
   StartIndex, EndIndex: integer;
  begin
    ConvertUCS4ToUCS2:=UNICODE_ERR_OK;
  
    { Check if only one character is passed as src, in that case
      this is not an UTF string, but a simple character (in other
      words, there is not a length byte.
    }
    if High(src) = 0 then
      begin
        StartIndex:=0;
        EndIndex:=0;
        dst[0]:=ucs2char(1);
      end
    else
      begin
        StartIndex:=1;
        EndIndex:=UCS4_Length(src);
        dst[0]:=ucs2char(ucs4_length(src));
      end;
  
    for i:=StartIndex to EndIndex do
      begin
        ch:=src[i];
        if ch > UNI_MAX_BMP then
          begin 
            ConvertUCS4ToUCS2:=UNICODE_ERR_INCOMPLETE_CONVERSION;
            continue;
          end;
        dst[i]:=ucs2char(ch and UNI_MAX_BMP);
      end;
  end;
  
  
  function ConvertUCS2ToUCS4(src: array of ucs2char; var dst: ucs4string): integer;
  var
   ch: ucs4char;
   i: integer;
   StartIndex, EndIndex: integer;
  begin
    ConvertUCS2ToUCS4:=UNICODE_ERR_OK;
  
    { Check if only one character is passed as src, in that case
      this is not an UCS string, but a simple character (in other
      words, there is not a length byte.
    }
    if High(src) = 0 then
      begin
        StartIndex:=0;
        EndIndex:=0;
        dst[0]:=ucs4char(1);
      end
    else
      begin
        StartIndex:=1;
        EndIndex:=UCS2_Length(src);
       ucs4_setlength(dst,ucs2_length(src));
      end;
    for i:=StartIndex to EndIndex do
      begin
        ch:=src[i];
        if not ucs2_isvalid(ch and $ffff) then
          begin 
            ConvertUCS2ToUCS4:=UNICODE_ERR_SOURCEILLEGAL;
            continue;
          end;
        dst[i]:=ucs4char(ch);
      end;
  end;

    procedure utf8stringdispose(var p : putf8shortstring);
      begin
         if assigned(p) then
           freemem(p,length(p^)+1);
         p:=nil;
      end;


    function utf8stringdup(const s : string) : putf8shortstring;
      var
         p : putf8shortstring;
      begin
         getmem(p,length(s)+1);
         p^:=s;
         utf8stringdup:=p;
      end;

{---------------------------------------------------------------------------
                          UCS-4 string handling
-----------------------------------------------------------------------------}

function ucs4_upcase(c: ucs4char): ucs4char;
var
  First: Integer;
  Last: Integer;
  Pivot: Integer;
begin
  First  := 1; {Sets the first item of the range}
  Last   := MAX_CASETABLE; {Sets the last item of the range}
  ucs4_upcase := c; {Initializes the Result}

  { If First > Last then the searched item doesn't exist
    If the item is found the loop will stop }
  while (First <= Last) do
  begin
    { Gets the middle of the selected range }
    Pivot := (First + Last) div 2;
    { Compares the String in the middle with the searched one }
    if CaseTable[Pivot].lower = c then
    begin
      ucs4_upcase := CaseTable[Pivot].upper;
      exit;
    end
    { If the Item in the middle has a bigger value than
      the searched item, then select the first half }
    else if CaseTable[Pivot].lower > c then
      Last := Pivot - 1
        { else select the second half}
    else
      First := Pivot + 1;
  end;
end;


  procedure ucs4_removeaccents(var resultstr: ucs4string;s2: ucs4string);
  var
   slen: integer;
   i,j: integer;
  begin
    slen:=ucs4_length(s2);
    ucs4_setlength(resultstr,slen);
    for i:=1 to slen do 
      begin
         for j:=1 to MAX_CANONICAL_MAPPINGS do
           begin
             if (CanonicalMap^[j].CodePoint = s2[i]) then
               begin
                 s2[i] := CanonicalMap^[j].BaseChar;
                 { There cannot be more than one match }
                 break;
               end;
           end;
      end;
    Move(s2,ResultStr, slen*sizeof(ucs4char)+sizeof(ucs4char));  
  end;
  
  
  function ucs4_getbasechar(c: ucs4char): ucs4char;
  var
   slen: integer;
   j: integer;
  begin
    ucs4_getbasechar:=c;
    for j:=1 to MAX_CANONICAL_MAPPINGS do
      begin
        if (CanonicalMap^[j].CodePoint = c) then
           begin
              ucs4_getbasechar := CanonicalMap^[j].BaseChar;
              exit;
           end;
      end;
  end;
  
  
  function ucs4_lowcase(c: ucs4char): ucs4char;
  var
   i: integer;
  begin
    { Assume there is no uppercase for this character }
    ucs4_lowcase:=c;
    for i:=1 to MAX_CASETABLE do
      begin
        if (c = CaseTable[i].upper) then
          begin
           ucs4_lowcase:=CaseTable[i].lower;
           exit;
          end; 
      end;
  end;


function ucs4_isterminal(c: ucs4char): boolean;
var
  First: Integer;
  Last: Integer;
  Pivot: Integer;
begin
  First  := 1; {Sets the first item of the range}
  Last   := MAX_TERMINALS; {Sets the last item of the range}
  ucs4_isterminal := false; {Initializes the Result}

  { If First > Last then the searched item doesn't exist
    If the item is found the loop will stop }
  while (First <= Last) do
  begin
    { Gets the middle of the selected range }
    Pivot := (First + Last) div 2;
    { Compares the String in the middle with the searched one }
    if (c >= terminals[Pivot].lower) and (c <= terminals[Pivot].upper) then
    begin
      ucs4_isterminal := true;
      break;
    end
    { If the Item in the middle has a bigger value than
      the searched item, then select the first half }
    else if terminals[Pivot].lower > c then
      Last := Pivot - 1
        { else select the second half}
    else
      First := Pivot + 1;
  end;
end;

function ucs4_ishexdigit(c: ucs4char): boolean;
var
 i: integer;
begin
  ucs4_ishexdigit:=true;
  if chr(c) in ['A'..'F','a'..'f','0'..'9'] then 
    exit;
  { Fullwidth versions }  
  for i:=1 to MAX_HEXDIGITS do
   begin
    if (c >= HexDigits[i].lower) and (c <= HexDigits[i].lower) then
       exit;
   end;
  ucs4_ishexdigit:=false;  
end;



function ucs4_isdigit(c: ucs4char): boolean;
var
  First: Integer;
  Last: Integer;
  Pivot: Integer;
begin
  First  := 1; {Sets the first item of the range}
  Last   := MAX_DIGITS; {Sets the last item of the range}
  ucs4_isdigit := false; {Initializes the Result}

  { If First > Last then the searched item doesn't exist
    If the item is found the loop will stop }
  while (First <= Last) do
  begin
    { Gets the middle of the selected range }
    Pivot := (First + Last) div 2;
    { Compares the String in the middle with the searched one }
    if digits[Pivot] = c then
    begin
      ucs4_isdigit := true;
      break;
    end
    { If the Item in the middle has a bigger value than
      the searched item, then select the first half }
    else if digits[Pivot] > c then
      Last := Pivot - 1
        { else select the second half}
    else
      First := Pivot + 1;
  end;
end;


function ucs4_getNumericValue(c: ucs4char): longint;
var
  First: Integer;
  Last: Integer;
  Pivot: Integer;
begin
  First  := 1; {Sets the first item of the range}
  Last   := MAX_NUMERIC_MAPPINGS; {Sets the last item of the range}
  ucs4_getnumericvalue := -1; {Initializes the Result}

  { If First > Last then the searched item doesn't exist
    If the item is found the loop will stop }
  while (First <= Last) do
  begin
    { Gets the middle of the selected range }
    Pivot := (First + Last) div 2;
    { Compares the String in the middle with the searched one }
    if (c = NumericalMappings[Pivot].CodePoint) then
    begin
      ucs4_getnumericvalue := NumericalMappings[Pivot].Value;
      break;
    end
    { If the Item in the middle has a bigger value than
      the searched item, then select the first half }
    else if NumericalMappings[Pivot].CodePoint > c then
      Last := Pivot - 1
        { else select the second half}
    else
      First := Pivot + 1;
  end;
end;




function ucs4_iswhitespace(c: ucs4char): boolean;
var
  First: Integer;
  Last: Integer;
  Pivot: Integer;
begin
  First  := 1; {Sets the first item of the range}
  Last   := MAX_WHITESPACE; {Sets the last item of the range}
  ucs4_iswhitespace := false; {Initializes the Result}

  { If First > Last then the searched item doesn't exist
    If the item is found the loop will stop }
  while (First <= Last) do
  begin
    { Gets the middle of the selected range }
    Pivot := (First + Last) div 2;
    { Compares the String in the middle with the searched one }
    if (c >= whitespace[Pivot].lower) and (c <= whitespace[Pivot].upper) then
    begin
      ucs4_iswhitespace := true;
      break;
    end
    { If the Item in the middle has a bigger value than
      the searched item, then select the first half }
    else if whitespace[Pivot].lower > c then
      Last := Pivot - 1
        { else select the second half}
    else
      First := Pivot + 1;
  end;
end;

  
  procedure ucs4_copy(var resultstr: ucs4string; const s: ucs4string; index: integer; count: integer);
  var
   slen: integer;
  begin
    ucs4_setlength(resultstr,0);
    if count = 0 then
      exit;
    slen:=ucs4_length(s);
    if index > slen then
      exit;
    if (count+index)>slen then
      count:=slen-index+1;
    { don't forget the length character }
    Move(s[index],resultstr[1],count*sizeof(ucs4char));
    ucs4_setlength(resultstr,count);
  end;
  
  procedure ucs4_delete(var s: ucs4string; index: integer; count: integer);
  begin
    if index<=0 then
      exit;
    if (Index<=UCS4_Length(s)) and (Count>0) then
     begin
       if Count>UCS4_length(s)-Index then
        Count:=UCS4_length(s)-Index+1;
       s[0]:=(UCS4_length(s)-Count);
       if Index<=ucs4_Length(s) then
        Move(s[Index+Count],s[Index],(UCS4_Length(s)-Index+1)*sizeof(ucs4char));
     end;
  end;
  

  procedure ucs4_concat(var resultstr: ucs4string;const s1: ucs4string; const s2: array of ucs4char);
  var
    s1l, s2l : integer;
  begin
    { if only one character must be moved }
    if high(s2) = 0 then
      begin
        s2l:=1;
        s1l:=ucs4_length(s1);
        if (s2l+s1l)>MAX_STRING_LENGTH then
          exit;
        move(s1[1],resultstr[1],s1l*sizeof(ucs4char));
        resultstr[s1l+1]:=s2[0];
        ucs4_setlength(resultstr, s2l+s1l);
        exit;
      end;
    s2l:=ucs4_length(s2);
    s1l:=ucs4_length(s1);
    if (s2l+s1l)>MAX_STRING_LENGTH then
      s2l:=MAX_STRING_LENGTH-s1l;
    move(s1[1],resultstr[1],s1l*sizeof(ucs4char));
    if s2l <> 0 then
      move(s2[1],resultstr[s1l+1],s2l*sizeof(ucs4char));
    ucs4_setlength(resultstr, s2l+s1l);
  end;

  function ucs4_pos(const substr: ucs4string; const s: ucs4string): integer;
  var
    i,j : integer;
    e   : boolean;
    Substr2: ucs4string;
  begin
    i := 0;
    j := 0;
    e:=(ucs4_length(SubStr)>0);
    while e and (i<=ucs4_Length(s)-ucs4_Length(SubStr)) do
     begin
       inc(i);
       ucs4_Copy(Substr2,s,i,ucs4_Length(Substr));
       if (SubStr[1]=s[i]) and (ucs4_equal(Substr,Substr2)) then
        begin
          j:=i;
          e:=false;
        end;
     end;
    ucs4_Pos:=j;
  end;
  
  function ucs4_equal(const s1,s2: ucs4string): boolean;
    var
     i: integer;
     s1length: integer;
  begin
    ucs4_equal:=false;
    if ucs4_length(s1) <> ucs4_length(s2) then
      exit;
    s1length:= ucs4_length(s1); 
    for i:=1 to s1length do
      begin
        if s1[i] <> s2[i] then
          exit;
      end;
    ucs4_equal:=true;
  end;
  

  function ucs4_length(const s: array of ucs4char): integer;
  begin
   ucs4_length:=integer(s[0]);
  end;
  
  procedure ucs4_setlength(var s: array of ucs4char; l: integer);
  begin
   if l > MAX_STRING_LENGTH then
     l:=MAX_STRING_LENGTH;
   s[0]:=ucs4char(l);
  end;

  procedure ucs4_concatascii(var resultstr: ucs4string;const s1: ucs4string; const s2: string);
  var
   utfstr: ucs4string;
  begin
    if ConvertToUCS4(s2,utfstr,'ASCII')  = UNICODE_ERR_OK then
       ucs4_concat(resultstr,s1,utfstr);
  end;

  function ucs4_posascii(const substr: string; const s: ucs4string): integer;
  var
   utfstr: ucs4string;
  begin
    ucs4_posascii:=0;
    if ConvertToUCS4(substr,utfstr,'ASCII')  = UNICODE_ERR_OK then
     ucs4_posascii:=ucs4_pos(utfstr,s);
  end;

  function ucs4_equalascii(const s1 : array of ucs4char; s2: string): boolean;
  var
   utfstr: ucs4string;
   s3: ucs4string;
   i: integer;
   s1length: integer;
  begin
    ucs4_equalascii:=false;
    s1length:=ucs4_length(s1);
    for i:=1 to s1length do
      begin
        s3[i] := s1[i];
      end;
    ucs4_setlength(s3,ucs4_length(s1));
    if ConvertToUCS4(s2,utfstr,'ASCII')  = UNICODE_ERR_OK then
     ucs4_equalascii:=ucs4_equal(utfstr,s3);
  end;

  function ucs4_issupported(s: string): boolean;
  var
   i: integer;
  begin
    s:=upstring(s);
    ucs4_issupported := true;
    if (s = 'UTF-16') or (s = 'UTF-16BE') or (s = 'UTF-16LE') or
       (s = 'UCS-4') or (s = 'UCS-4BE') or (s = 'UCS-4LE') or
       (s = 'UTF-8') then
     begin
        ucs4_issupported := true;
        exit;
     end;
    for i:=1 to MAX_ALIAS do
    begin
      if aliaslist[i].aliasname = s then
      begin
         ucs4_issupported := true;
         exit;
      end;
    end;
  end;
  
  function ucs4_converttoiso8859_1(const s: ucs4string): string;
  var
   resultstr: string;
   i: integer;
   maxlength: integer;
  begin
   resultstr:='';
   maxlength:=ucs4_length(s);
   for i:=1 to maxlength do
     begin
       if s[i] <= 255 then
         begin
           resultstr:=resultstr+chr(s[i]);
         end
       else
         begin
           resultstr:=resultstr+'\u'+hexstr(longint(s[i]),8);
         end;
     end;
   ucs4_converttoiso8859_1:=resultstr;  
  end;
  
  
  function ucs4_converttoutf8(const src: ucs4string): utf8string;
  var
   p: pucs4char;
   len: integer;
  begin
    len:=ucs4_length(src)*sizeof(ucs4char)+sizeof(ucs4char);
    Getmem(p,len);
    ucs4strpcopy(p,src);
    ucs4_converttoutf8:=ucs4strpastoutf8(p);
    if assigned(p) then
      Freemem(p,len);
  end;
  
  
  
  function ucs4_isvalid(c: ucs4char): boolean;
  begin
    ucs4_isvalid := false;
    { maximum unicode range }
    if (c > UNI_MAX_UTF16) then
       exit;
    { surrogates are not allowed in this encoding }
    if (c >= UNI_SUR_HIGH_START) and (c <= UNI_SUR_HIGH_END) then
      exit;
    if (c >= UNI_SUR_LOW_START) and (c <= UNI_SUR_LOW_END) then
      exit;
    { check for non-characters, which are not allowed in 
      interchange data
    }  
    if (c and $FFFF) = $FFFE then exit;
    if (c and $FFFF) = $FFFF then exit;
    ucs4_isvalid := true;
  end;

  procedure ucs4_trim(var s: ucs4string);
  begin
    ucs4_trimleft(s);
    ucs4_trimright(s);
  end;


  procedure UCS4_TrimLeft(var S: ucs4string);
  var i,l:integer;
      outstr: ucs4string;
  begin
    ucs4_setlength(outstr,0);
    l := ucs4_length(s);
    i := 1;
    while (i<=l) and (ucs4_iswhitespace(s[i])) do
     inc(i);
    ucs4_copy(outstr,s, i, l);
    move(outstr,s,sizeof(ucs4string));
  end ;


  procedure UCS4_TrimRight(var S: ucs4string);
  var l:integer;
      outstr: ucs4string;
  begin
    ucs4_setlength(outstr,0);
    l := ucs4_length(s);
    while (l>0) and (ucs4_iswhitespace(s[l])) do
     dec(l);
    ucs4_copy(outstr,s,1,l);
    move(outstr,s,sizeof(ucs4string));
  end ;


  function utf16_sizeencoding(c: utf16char): integer;
  begin
    utf16_sizeencoding:=2;
    if (c >= UNI_SUR_HIGH_START) and (c <= UNI_SUR_HIGH_END) then
      utf16_sizeencoding:=4;
  end;
  
  function utf8_sizeencoding(c: utf8char): integer;
  begin
    utf8_sizeencoding:= trailingBytesForUTF8[ord(c)]+1;
  end;
  
  
  function ucs2_length(const s: array of ucs2char): integer;
  begin
   ucs2_length:=integer(s[0]);
  end;
  
  procedure ucs2_setlength(var s: array of ucs2char; l: integer);
  begin
   if l > MAX_STRING_LENGTH then
     l:=MAX_STRING_LENGTH;
   s[0]:=ucs2char(l);
  end;
  
  
function ucs2_upcase(c: ucs2char): ucs2char;
var
  First: Integer;
  Last: Integer;
  Pivot: Integer;
begin
  First  := 1; {Sets the first item of the range}
  Last   := MAX_UCS2_CASETABLE; {Sets the last item of the range}
  ucs2_upcase := c; {Initializes the Result}

  { If First > Last then the searched item doesn't exist
    If the item is found the loop will stop }
  while (First <= Last) do
  begin
    { Gets the middle of the selected range }
    Pivot := (First + Last) div 2;
    { Compares the String in the middle with the searched one }
    if CaseTable[Pivot].lower = c then
    begin
      ucs2_upcase := CaseTable[Pivot].upper;
      exit;
    end
    { If the Item in the middle has a bigger value than
      the searched item, then select the first half }
    else if CaseTable[Pivot].lower > c then
      Last := Pivot - 1
        { else select the second half}
    else
      First := Pivot + 1;
  end;
end;
  

{---------------------------------------------------------------------------
                   UCS-4 null terminated string handling
-----------------------------------------------------------------------------}

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

 function ucs4strpasToISO8859_1(Str: pucs4char): string;
  var
   i: integer;
   lstr: string;
   stringarray: pucs4strarray;
 Begin
   ucs4strpasToISO8859_1:='';
   if not assigned(str) then exit;
   stringarray := pointer(str);
   setlength(lstr,0);
   for i:=1 to ucs4strlen(str) do
     begin
       if i >= high(ucs4string) then break;
       if Stringarray^[i-1] <= MAX_STRING_LENGTH then
          lstr := lstr + chr(Stringarray^[i-1])
       else
          lstr := lstr + '\u'+hexstr(Stringarray^[i-1],8);
     end;
   ucs4strpasToISO8859_1:= lstr;
 end;

 function ucs4strpasToASCII(Str: pucs4char): string;
  var
   counter : integer;
   lstr: string;
   stringarray: pucs4strarray;
 Begin
   counter := 0;
   ucs4strpasToASCII:='';
   if not assigned(str) then exit;
   stringarray := pointer(str);
   setlength(lstr,0);
   while ((stringarray^[counter]) <> 0) and (counter < high(ucs4string)) do
   begin
     Inc(counter);
     if Stringarray^[counter-1] <= 127 then
        lstr := lstr + chr(Stringarray^[counter-1])
     else
        lstr := lstr + '\u'+hexstr(Stringarray^[counter-1],8);
   end;
   ucs4strpasToASCII:= lstr;
 end;
 


 procedure ucs4strpas(Str: pucs4char; var res:ucs4string);
  var
   counter : integer;
   lstr: ucs4string;
   stringarray: pucs4strarray;
 Begin
   counter := 0;
   stringarray := pointer(str);
   ucs4_setlength(res,0);
   ucs4_setlength(lstr,0);
   if not assigned(str) then exit;
   while ((stringarray^[counter]) <> 0) and (counter < high(ucs4string)) do
   begin
     Inc(counter);
     ucs4_concat(lstr, lstr, Stringarray^[counter-1]);
   end;
   UCS4_SetLength(lstr,counter);
   res := lstr;
 end;
 

  function ucs4StrPosISO8859_1(S: pucs4char; Str2: PChar): pucs4char;
 var
  count: Longint;
  oldindex: Longint;
  found: boolean;
  Str1Length: Longint;
  Str2Length: Longint;
  ll: Longint;
  str1: pucs4strarray;
 Begin
   ucs4strposISO8859_1:=nil;
   if not assigned(s) then
     exit;
   if not assigned(str2) then
     exit;
   str1 := pointer(s);
   Str1Length := UCS4StrLen(s);
   Str2Length := StrLen(Str2);
   oldindex := 0;

   { If the search string is greater than the string to be searched }
   { it is certain that we will not find it.                        }
   { Furthermore looking for a null will simply give out a pointer, }
   { to the null character of str1 as in Borland Pascal.            }
   if (Str2Length > Str1Length) or (Str2[0] = #0) then
   begin
     UCS4StrPosISO8859_1 := nil;
     exit;
   end;

   Repeat
     { Find first matching character of Str2 in Str1 }
     { put index of this character in oldindex       }
     for count:= oldindex to Str1Length-1 do
     begin
        if ucs4char(Str2[0]) = Str1^[count] then
        begin
           oldindex := count;
           break;
        end;
        { nothing found - exit routine }
        if count = Str1Length-1 then
        begin
           UCS4StrPosISO8859_1 := nil;
           exit;
        end;
     end;

     found := true;
     { Compare the character strings }
     { and check if they match.      }
     for ll := 0 to Str2Length-1 do
     begin
       { no match, stop iteration }
        if (ucs4char(Str2[ll]) <> Str1^[ll+oldindex]) then
        begin
           found := false;
           break;
        end;
     end;
     { Not found, the index will no point at next character }
     if not found then
       Inc(oldindex);
     { There was a match }
     if found then
     begin
        UCS4StrPosISO8859_1 := @(Str1^[oldindex]);
        exit;
     end;
   { If we have gone through the whole string to search }
   { then exit routine.                                 }
   Until (Str1Length-oldindex) <= 0;
   UCS4StrPosISO8859_1 := nil;
 end;

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
            if aliaslist[i].aliasname = srctype then
              begin
                p:=aliaslist[i].table;
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


 procedure ucs4removenulls(s: ucs4string; var dest: ucs4string);
 var
  outstr: ucs4string;
  i,j: integer;
  endindex:integer;
 begin
  { Allocate at least enough memory if using ansistrings }
  ucs4_setlength(outstr,ucs4_length(s));
  j:=1;
  endindex:=ucs4_length(s);
  for i:=1 to endindex do
    begin
      if s[i] <> 0 then
      begin
        outstr[j]:=s[i];
        inc(j);
      end;
    end;
  ucs4_setlength(outstr,j-1);
  dest:=outstr;
 end;

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
            if aliaslist[i].aliasname = srctype then
              begin
                p:=aliaslist[i].table;
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

 function ucs4strdispose(str: pucs4char): pucs4char;
 begin
    ucs4strdispose := nil;
    if not assigned(str) then
      exit;
    { don't forget to free the null character }
    Freemem(str,ucs4strlen(str)*sizeof(ucs4char)+sizeof(ucs4char));
    str:=nil;
 end;


 Function UCS4StrPCopy(Dest: Pucs4char; Source: UCS4String):PUCS4Char;
   var
    counter : integer;
    stringarray: pucs4strarray;
    stringlength: integer;

  Begin
   { remove any null characters from the string }
   ucs4removenulls(source,source);
   stringarray:=pointer(Dest);
   UCS4StrPCopy := nil;
   if not assigned(Dest) then
     exit;
   { if empty pascal string  }
   { then setup and exit now }
   if ucs4_length(Source) = 0 then
   Begin
     stringarray^[0] := 0;
     UCS4StrPCopy := pointer(StringArray);
     exit;
   end;
   stringlength:=ucs4_length(Source);
   for counter:=1 to stringlength do
   begin
     StringArray^[counter-1] := Source[counter];
   end;
   { terminate the string }
   StringArray^[ucs4_length(Source)] := 0;
   UCS4StrPCopy:=Dest;
 end;

  function ucs4strtrim(const p: pucs4char): pucs4char;
  var
   i: integer;
   lastindex: integer;
   inbuf,outbuf,outbuf1: pucs4strarray;
   allocsize: integer;
   allocsize1: integer;
  begin
    ucs4strtrim:=nil;
    if not assigned(p) then
      exit;
    { allocate a copy of the string that will be overwritten }
    lastindex := ucs4strlen(p)+1;
    allocsize:=lastindex*sizeof(ucs4char);
    Getmem(outbuf,allocsize);
    inbuf:=pucs4strarray(p);
    i := 0;
    while (i<=lastindex) and (ucs4_iswhitespace(inbuf^[i])) do
      inc(i);
    move(inbuf^[i],outbuf^,(lastindex-i)*sizeof(ucs4char));

    lastindex := ucs4strlen(pucs4char(outbuf))+1;
    allocsize1:=lastindex*sizeof(ucs4char);
    Getmem(outbuf1,allocsize1);
    inbuf:=pucs4strarray(outbuf);
    { No null character, and forget to decrease because index starts at zero }
    i:=ucs4strlen(pucs4char(outbuf))-1;
    while (i>=0) and (ucs4_iswhitespace(inbuf^[i])) do
       dec(i);
    if i >= 0 then
      begin
        move(inbuf^,outbuf1^,(i+1)*sizeof(ucs4char));
        { add the null character }
        outbuf1^[i+1]:=0;
      end
    else
        { add the null character }
        outbuf1^[0]:=0;

    ucs4strtrim:=ucs4strnewucs4(pucs4char(outbuf1));
    Freemem(outbuf,allocsize);
    Freemem(outbuf1,allocsize1);
  end;

  function ucs4strfill(var p: pucs4char; count: integer; value: ucs4char): pucs4char;
  var
   outbuf: pucs4strarray;
   i: integer;
  begin
    outbuf:=pucs4strarray(p);
    if count > 0 then
      begin
        for i:=1 to count do
          begin
            outbuf^[i-1]:=value;
          end;
      end;
   ucs4strfill:=pucs4char(outbuf);
  end;
  
  procedure UCS4StrCheck(p: pucs4char; maxcount: integer; value: ucs4char);
  var
   inbuf: pucs4strarray;
   i: integer;
   firstindex: integer;
   maxval: integer;
  begin
    inbuf:=pucs4strarray(p);
    { Now search for null }
    maxval:=maxcount-1;
    firstindex:=0;
    for i:=0 to maxval do
    begin
      if inbuf^[i] = 0 then
        break;
      inc(firstindex);
    end;
    { No null! }
    if (firstindex = maxcount) then
      RunError(255);
    { Now check the values }
    if firstindex <= maxcount then
      begin
        { first index should point to the null now }
        inc(firstindex);
        for i:=firstindex to maxval do
          if inbuf^[i] <> value then
             RunError(255);
      end;
  end;


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
      if Outindex > High(utf8string) then
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


{---------------------------------------------------------------------------
                   UTF-8 null terminated string handling
-----------------------------------------------------------------------------}

  function utf8strdispose(p: pchar): pchar;
  begin
    utf8strdispose := nil;
    if not assigned(p) then
      exit;
    Freemem(p,strlen(p)+1);
    p:=nil;
  end;
  
  
  function utf8strlen(s: putf8char): integer;
  begin
    utf8strlen:=0;
    if not assigned(s) then
      exit;
    utf8strlen:=strlen(s);  
  end;
  

  function utf8strnewutf8(src: pchar): pchar;
  var
   lengthtoalloc: integer;
   dst: pchar;
  begin
    utf8strnewutf8:=nil;
    if not assigned(src) then
      exit;
    lengthtoalloc:=strlen(src)+sizeof(utf8char);
    if lengthtoalloc = sizeof(char) then
      exit;
    { also copy the null character }
    Getmem(dst,lengthtoalloc);
    move(src^,dst^,lengthtoalloc);
    utf8strnewutf8:=dst;
  end;
  

  function UTF8StrNew(src: pucs4char): pchar;
  var
   ucs4stringlen: integer;
   p: pchar;
   ch: ucs4char;
   idx: integer;
   OutIndex,BytesToWrite,StartIndex: integer;
   CurrentIndex, EndIndex: integer;
   i: integer;
   ResultPtr: putf8char;
   instr: pucs4strarray;
   sizetoalloc: integer;
  begin
    utf8strnew:=nil;
    if not assigned(src) then 
      exit;
    ucs4stringlen:=ucs4strlen(src);
    { Let us not forget the terminating null character }
    sizetoalloc:=ucs4stringlen*sizeof(ucs4char)+sizeof(ucs4char);
    instr:=pointer(src);
    { allocate at least the space taken up by the
      strlen*4 - because each character can take up to 4 bytes.
    }  
    GetMem(p,sizetoalloc);
{    fillchar(p^,sizetoalloc,0);}
    p[0]:=#0;
    OutIndex := 0;
    StartIndex:=0;
    EndIndex:=ucs4stringlen-1;
    p[EndIndex+1]:=#0;

    for i:=StartIndex to EndIndex do
     begin
       ch:=instr^[i];

       if (ch > UNI_MAX_UTF16) then
       begin
         UTF8StrNew := nil;
         FreeMem(p,sizetoalloc);
         exit;
       end;


       if ((ch >= UNI_SUR_HIGH_START) and (ch <= UNI_SUR_LOW_END)) then
       begin
         UTF8StrNew := nil;
         FreeMem(p,sizetoalloc);
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

       CurrentIndex := BytesToWrite-1;
       for idx:=CurrentIndex downto 1 do
         begin
           dec(OutIndex);
           p[outindex] := utf8char((ch or byteMark) and ByteMask);
           ch:=ch shr 6;
         end;
       dec(OutIndex);
       p[outindex] := utf8char((byte(ch) or byte(FirstbyteMark[BytesToWrite])));
       Inc(OutIndex,BytesToWrite);
     end;
      { Copy the values, and free the old buffer }
      Getmem(ResultPtr,Outindex+1);
      move(p^,ResultPtr^,Outindex);
      FreeMem(pointer(p),sizetoalloc);
      ResultPtr[OutIndex] := #0;
      UTF8StrNew:=ResultPtr;
  end;


  function utf8strlcopyucs4(src: pchar; dst: pucs4char; maxlen: integer): pucs4char;
  var
   ch: ucs4char;
   i: integer;
   StringLength: integer;
   Outindex: integer;
   ExtraBytesToRead: integer;
   CurrentIndex: integer;
   stringarray: pucs4strarray;
  
  begin
    utf8strlcopyucs4:=nil;
    if not assigned(src) then
      exit;
    if not assigned(dst) then
      exit;
    i:=0;
    stringarray:=pointer(dst);
    stringlength := 0;
    OutIndex := 1;
    while (src[i] <> #0) and (i < maxlen) do
      begin
        ch := 0;
        extrabytestoread:= trailingBytesForUTF8[ord(src[i])];
        if (stringlength + extraBytesToRead) >= high(ucs4string) then
          begin
            exit;
          end;
{        if not isLegalUTF8(src, extraBytesToRead+1) then
          begin
            exit;
          end;}
        CurrentIndex := ExtraBytesToRead;
        if CurrentIndex = 5 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 4 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 3 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 2 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 1 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 0 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
        end;
        ch := ch - offsetsFromUTF8[extraBytesToRead];
        if (ch <= UNI_MAX_UTF32) then
          begin
            stringarray^[OutIndex] := ch;
            inc(OutIndex);
          end
        else
          begin
            stringarray^[OutIndex] := UNI_REPLACEMENT_CHAR;
            inc(OutIndex);
          end;
      end;
      stringarray^[outindex] := 0;
      utf8strlcopyucs4:=dst;
  end;


  function utf8strpastostring(src: pchar; desttype: string): string;
  var
   ch: ucs4char;
   s: string;
   i: integer;
   StringLength: integer;
   ExtraBytesToRead: integer;
   p: pchararray;
   j: char;
   idx: integer;
   found: boolean;
  begin
    setlength(s,0);
    utf8strpastostring:='';
    if not assigned(src) then
       exit;
    p:=nil;
    desttype:=upstring(desttype);
    { If the desitnation type if UTF-8, simple, directly convert and exit }
    if desttype = 'UTF-8' then
      begin
         utf8strpastostring:=strpas(src);
         exit;
      end;
    for i:=1 to MAX_ALIAS do
     begin
      if aliaslist[i].aliasname = desttype then
        begin
          p:=aliaslist[i].table;
          break;
        end;
     end;
    i:=0;
    { Could not be found, then exit without doing nothing... }
    if not assigned(p) then
       exit;
    stringlength := strlen(src);
    while i < stringlength do
      begin
        ch := 0;
        extrabytestoread:= trailingBytesForUTF8[ord(src[i])];
        if (stringlength + extraBytesToRead) >= high(ucs4string) then
          begin
            exit;
          end;
          
        for idx:=ExtraBytesToRead downto 1 do
          begin
            ch:=ch + ucs4char(src[i]);
            inc(i);
            ch:=ch shl 6;
          end;
        ch:=ch + ucs4char(src[i]);
        inc(i);
        
        ch := ch - offsetsFromUTF8[extraBytesToRead];
        { search the table for the character by reverse lookup }
        found:=false;
        for j:=#0 to high(char) do 
          begin     
            if ucs4char(ch) = ucs4char(p^[j]) then
              begin
                s:=s+j;
                found:=true;
                break;
              end;
          end;
        if not found then
          begin
            s:=s+'\u'+hexstr(longint(ch),8);
          end;
      end;
     utf8strpastostring:=s;
  end;

  
  function utf8strpastoISO8859_1(src: pchar): string;
  var
   ch: ucs4char;
   s: string;
   i: integer;
   StringLength: integer;
   idx: integer;
   ExtraBytesToRead: integer;
  begin
    i:=0;
    setlength(s,0);
    utf8strpastoISO8859_1:='';
    if not assigned(src) then
       exit;
    stringlength := strlen(src);
    while i < stringlength do
      begin
        ch := 0;
        extrabytestoread:= trailingBytesForUTF8[ord(src[i])];
        if (stringlength + extraBytesToRead) >= high(ucs4string) then
          begin
            exit;
          end;
        for idx:=ExtraBytesToRead downto 1 do
          begin
            ch:=ch + ucs4char(src[i]);
            inc(i);
            ch:=ch shl 6;
          end;
        ch:=ch + ucs4char(src[i]);
        inc(i);
        ch := ch - offsetsFromUTF8[extraBytesToRead];
        if (ch <= UNI_MAX_UTF32) then
          begin
            if ch > 255 then
              begin
                s:= s + '\u' + hexstr(ch,8);
              end
            else
               s:=s+chr(ch and $ff);
          end
        else
          begin
            if ch > 255 then
              begin
                s:= s + '\u' + hexstr(ch,8);
              end
            else
               s:=s+chr(ch and $ff);
          end;
      end;
     utf8strpastoISO8859_1:=s;
  end;


  function utf8strpastoascii(src: pchar): string;
  var
   ch: ucs4char;
   s: string;
   i: integer;
   idx: integer;
   StringLength: integer;
   ExtraBytesToRead: integer;
   ResultStr: ucs4string;
   ucs4str: ucs4string;
  begin
    i:=0;
    setlength(s,0);
    utf8strpastoASCII:='';
    if not assigned(src) then
       exit;
    stringlength := strlen(src);
    while i < stringlength do
      begin
        ch := 0;
        extrabytestoread:= trailingBytesForUTF8[ord(src[i])];
        if (stringlength + extraBytesToRead) >= high(ucs4string) then
          begin
            exit;
          end;
        for idx:=ExtraBytesToRead downto 1 do
          begin
            ch:=ch + ucs4char(src[i]);
            inc(i);
            ch:=ch shl 6;
          end;
        ch:=ch + ucs4char(src[i]);
        inc(i);
        
        ch := ch - offsetsFromUTF8[extraBytesToRead];
        if (ch <= UNI_MAX_UTF32) then
          begin
            if ch > 127 then
              begin
                { Try to remove the accented character }
                ucs4_setlength(ucs4str,1);
                ucs4str[1]:=ch;
                ucs4_removeaccents(resultstr,ucs4str);
                assert(ucs4_length(resultstr) = 1);
                ch:=resultstr[1];
                { Some of the characters might have been converted to ascii }
                if ch > 127 then
                  s:= s + '\u' + hexstr(longint(ch),8)
                else
                  s:=s+chr(ch and $7f);
              end
            else
               s:=s+chr(ch and $7f);
          end
        else
          begin
            if ch > 127 then
              begin
                { Try to remove the accented character }
                ucs4_setlength(ucs4str,1);
                ucs4str[1]:=ch;
                ucs4_removeaccents(resultstr,ucs4str);
                assert(ucs4_length(resultstr) = 1);
                ch:=resultstr[1];
                { Some of the characters might have been converted to ascii }
                if ch > 127 then
                  s:= s + '\u' + hexstr(longint(ch),8)
                else
                  s:=s+chr(ch and $7f);
              end
            else
               s:=s+chr(ch and $7f);
          end;
      end;
     utf8strpastoASCII:=s;
  end;

  function utf8strpas(src: pchar): string;
  begin
    if src = nil then
      begin
        utf8strpas:='';
        exit;
      end;
    utf8strpas:=strpas(src);
  end;
  
  
  function asciistrnew(src: pchar): pchar;
  var
   lengthtoalloc: integer;
   dst: pchar;
  begin
    asciistrnew:=nil;
    if not assigned(src) then
      exit;
    lengthtoalloc:=strlen(src)+sizeof(utf8char);
    if lengthtoalloc = sizeof(char) then
      exit;
    { also copy the null character }
    Getmem(dst,lengthtoalloc);
    move(src^,dst^,lengthtoalloc);
    asciistrnew:=dst;
  end;
  
  function asciistrpas(src: pchar): string;
  begin
    if src = nil then
      begin
        asciistrpas:='';
        exit;
      end;
    asciistrpas:=strpas(src);
  end;
  
  
 function asciistrnewstr(const str: string): pchar;
 var
  p: putf8char;
 begin
   asciistrnewstr:=nil;
   p:=nil;
   if utf8_length(str) > 0 then
     begin
        getmem(p,utf8_length(str)+sizeof(utf8char));
        strpcopy(p,str);
        asciistrnewstr:=p;
     end;
 end;
  
  
  
 function ansistrnewstr(const str: string): pchar;
 var
  p: putf8char;
 begin
   ansistrnewstr:=nil;
   p:=nil;
   if utf8_length(str) > 0 then
     begin
        getmem(p,utf8_length(str)+sizeof(utf8char));
        strpcopy(p,str);
        ansistrnewstr:=p;
     end;
 end;
  
  
  function ansistrnew(src: pchar): pchar;
  var
   lengthtoalloc: integer;
   dst: pchar;
  begin
    ansistrnew:=nil;
    if not assigned(src) then
      exit;
    lengthtoalloc:=strlen(src)+sizeof(utf8char);
    if lengthtoalloc = sizeof(char) then
      exit;
    { also copy the null character }
    Getmem(dst,lengthtoalloc);
    move(src^,dst^,lengthtoalloc);
    ansistrnew:=dst;
  end;
  
  
  function ansistrpas(src: pchar): string;
  begin
    if src = nil then
      begin
        ansistrpas:='';
        exit;
      end;
    ansistrpas:=strpas(src);
  end;
  
  
  function ansistrdispose(p: pchar): pchar;
  begin
    ansistrdispose := nil;
    if not assigned(p) then
      exit;
    Freemem(p,strlen(p)+1);
    p:=nil;
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
 


  
  function ucs2_isvalid(ch: ucs2char): boolean;
  begin
    ucs2_isvalid := true;
    if ((ch >=  UNI_SUR_HIGH_START) and (ch <= UNI_SUR_HIGH_END)) or
           ((ch >=  UNI_SUR_LOW_START) and (ch <= UNI_SUR_LOW_END)) then
    begin 
      ucs2_isvalid := false;
    end;
  end;
  
  
{---------------------------------------------------------------------------
                   UCS-2 null terminated string handling
-----------------------------------------------------------------------------}

  function ucs2strlcopyucs4(src: pucs2char; dst: pucs4char; maxlen: integer): pucs4char;
  var
   i: integer;
   Outindex: integer;
   stringarray: pucs4strarray;
   srcarray: pucs2strarray;  
  begin
    ucs2strlcopyucs4:=nil;
    if not assigned(src) then
      exit;
    if not assigned(dst) then
      exit;
    i:=0;
    stringarray:=pointer(dst);
    srcarray:=pointer(src);
    OutIndex := 0;
    while (srcarray^[i] <> 0) and (i < maxlen) do
      begin
        stringarray^[outindex]:=srcarray^[i];
        inc(outindex);
        inc(i);
      end;
      stringarray^[outindex] := 0;
      ucs2strlcopyucs4:=dst;
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

  
procedure releaseresources;far;
begin
  ExitProc := ExitSave;
  if assigned(CanonicalMap) then
    Dispose(CanonicalMap);
end;


begin
  ExitSave:= ExitProc;
  ExitProc := @ReleaseResources;
  new(CanonicalMap);
{$ifdef tp}
    p:=@canonicmapping;
    move(p^,CanonicalMap^,sizeof(tcanonicalmappings));
{$else}    
    move(CanonicalMappings,CanonicalMap^,sizeof(tcanonicalmappings));
{$endif}
end.

{
  $Log: unicode.pas,v $
  Revision 1.46  2009/01/04 15:36:31  carl
   + utf8islegal for null terminated char strings.

  Revision 1.45  2007/01/06 19:23:51  carl
    + Turbo pascal support for canonical mapping without taking the full
       data segment.

  Revision 1.44  2006/12/23 23:14:44  carl
    * remove unused comments

  Revision 1.43  2006/12/06 21:13:53  ccodere
    + char based canonical analysis (unicode.pas)
    + Boyer-Moore search algorithm

  Revision 1.42  2006/11/10 04:07:24  carl
     + Unicode: ucs4_iswhitespace(), ucs4_isterminal(), ucs4_getnumericvalue()
        ucs4_ishexdigit(), ucs4_isdigit(). All tables are now public
        for easier parsing for ISO-8859-1 and ASCII character sets.
     + Utils: StrToken.
     + SGML: Support for all known entities

  Revision 1.41  2006/10/24 03:41:15  carl
   + MAX_STRING_LENGTH compromise, set to 2048 characters.

  Revision 1.40  2006/10/23 01:37:06  carl
    + UCs4String length is now 4096 characters insatead of 512

  Revision 1.39  2006/10/16 22:21:22  carl
  * ConvertFromUCS4()/ConvertToUCS4() would not work with UTF-8 strings

  Revision 1.38  2006/08/31 03:03:55  carl
  + Better documentation
  * Bugfixes when utf8string is declared as a standard shortstring, there could
    be memory corruption which could go undetected.

  Revision 1.37  2006/01/09 04:49:45  carl
    + Speed optimizations

  Revision 1.36  2005/12/01 01:48:43  carl
    + Updated before release

  Revision 1.35  2005/11/21 00:18:14  carl
    - remove some compilation warnings/hints
    + speed optimizations
    + recreated case.inc file from latest unicode casefolding standard

  Revision 1.34  2005/11/13 21:38:47  carl
    + ucs4_converttoutf8 added

  Revision 1.33  2005/11/09 05:18:02  carl
    + utf8strlen
    + binary search for ucs4_upcase (50-100% speed gain)

  Revision 1.32  2005/10/10 17:11:31  carl
   + When converting strings to ASCII, we try to convert to standard non-accented characters

  Revision 1.31  2005/08/08 12:03:49  carl
    + AddDoubleQuotes/RemoveDoubleQuotes
    + Add support for RemoveAccents in unicode

  Revision 1.30  2005/07/20 03:12:28  carl
   + Compilation problems fixes

  Revision 1.29  2005/03/06 20:13:50  carl
     * ucs4strpas would not work with ansistrings
     * ucs4strpastoutf8/convertUCS4ToUTF8: bugfix with possible overflow

  Revision 1.28  2005/01/30 20:07:11  carl
   + routine to convert from UCS-4 to ISO-8859-1

  Revision 1.27  2005/01/08 21:37:32  carl
    + added utf8strnewstr

  Revision 1.26  2005/01/06 03:26:38  carl
     * ucs4strnewstr fix with UTF-8, length was wrong for conversion.

  Revision 1.25  2004/12/26 23:32:39  carl
    + ucs4strnewucs2
    * some return value was never initialized when converting to UTF-8
    * bugfix of crashes when index is 0 in loops

  Revision 1.24  2004/12/08 04:25:38  carl
    * ucs4strpastoutf8 would not work on extended characters (would leave out some characters in the final string)

  Revision 1.23  2004/11/29 03:48:09  carl
    * ConvertUCS4ToUTF8 bugfix, was setting the wrong string length at the end.
    + destination and source string type aliases are now case-insensitive.

  Revision 1.22  2004/11/21 19:53:59  carl
    * 10-25% speed optimizations (change some parameter types to const, code folding)

  Revision 1.21  2004/11/09 03:51:42  carl
    + ucs4strtrim

  Revision 1.20  2004/10/31 19:54:06  carl
    + ucs4strnewucs4 routine
    * several range check error fixes
    * memory corruption fix with conversion routines

  Revision 1.19  2004/10/27 01:58:50  carl
   * strnew returns nil if the value passed is nil
   + clarification of some comments

  Revision 1.18  2004/10/13 23:25:43  carl
    - remove unused variables
    * bugfix of range check errors

  Revision 1.17  2004/09/16 02:32:58  carl
    * small fix in comments

  Revision 1.16  2004/09/06 20:35:33  carl
    * utf8string is now a shortstring

  Revision 1.15  2004/09/06 19:50:01  carl
    + Updated documentation

  Revision 1.14  2004/09/06 19:41:42  carl
    * Bugfix of UTF-8 encoded values with 4 and 5 characters (the original C code of unicode is wrong!)
    + utf8_islegal implemented to verify the validity of UTF-8 strings.

  Revision 1.13  2004/08/22 20:42:16  carl
    * range check error fix (memory read past end of buffer)

  Revision 1.12  2004/08/19 01:07:38  carl
    * other bugfix with memory corruption when copying the data

  Revision 1.11  2004/08/19 00:17:12  carl
    + renamed all basic types to use the UCS-4 type name instead.
    + Unicode case conversion of characters
    * several bugfixes in memory allocation with strings containing null characters

  Revision 1.10  2004/08/01 05:33:02  carl
    + more UTF-8 encoding routines
    * small bugfix in certain occasions with UCS-4 conversion

  Revision 1.9  2004/07/15 01:04:12  carl
    * small bugfixes
    - remove compiler warnings

  Revision 1.8  2004/07/05 02:38:15  carl
    + add collects unit
    + some small changes in cases of identifiers

  Revision 1.7  2004/07/05 02:27:32  carl
    - remove some compiler warnings
    + UCS-4 null character string handling routines
    + UTF-8 null character string handling routines

  Revision 1.6  2004/07/01 22:27:15  carl
    * Added support for Null terminated utf32 character string
    + renamed utf32 to utf32char

  Revision 1.5  2004/06/20 18:49:39  carl
    + added  GPC support

  Revision 1.4  2004/06/17 11:48:13  carl
    + UTF32 complete support
    + add UCS2 support

  Revision 1.3  2004/05/06 15:47:27  carl
    - remove some warnings

  Revision 1.2  2004/05/06 15:27:05  carl
     + add support for ISO8859, ASCII, CP850, CP1252 to UCS-4 conversion
       (and vice-versa)
     + add support for UCS-4 to UCS-2 conversion
     * bugfixes in conversion routines for UCS-4
     + updated documentation

  Revision 1.1  2004/05/05 16:28:22  carl
    Release 0.95 updates


}
  


