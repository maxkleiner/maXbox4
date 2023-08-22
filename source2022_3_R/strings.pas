{
    $Id: strings.pas,v 1.8 08/01/31 04:19:0carl Exp $
    This file is part of the Free Pascal run time library.
    Copyright (c) 1999-2000 by Carl-Eric Codere,
    member of the Free Pascal development team.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
Unit Strings;

  {*********************************************************************}
  { Strings unit, 100% portable.                                        }
  {- COMPILING INFORMATION ---------------------------------------------}
  {   The only difference between this  unit and the one supplied with  }
  {   Turbo Pascal 7.01, are that StrLen returns a longint, and the     }
  {   routines requiring a length now use longints instead of words.    }
  {   This should not influence the behaviour of your programs under    }
  {   Turbo Pascal. (it will even create better error checking for your }
  {   programs).                                                        }
  {*********************************************************************}

 Interface
 {*********************************************************************}
 { Returns the number of Characters in Str,not counting the Null       }
 { chracter.                                                           }
 {*********************************************************************}

function StrLen(Str: PChar): longint;


function StrEnd(Str: PChar): PChar;

  {*********************************************************************}
  {  Description: Move count characters from source to dest.            }
  {   Do not forget to use StrLen(source)+1 as l parameter to also move }
  {   the null character.                                               }
  {  Return value: Dest                                                 }
  {   Remarks: Source and Dest may overlap.                             }
  {*********************************************************************}

function StrMove(Dest,Source : Pchar;l : Longint) : pchar;


function StrCopy(Dest, Source: PChar): PChar;

 {*********************************************************************}
 {  Input: Source -> Source of the null-terminated string to copy.     }
 {         Dest   -> Destination of null terminated string to copy.    }
 {    Return Value: Pointer to the end of the copied string of Dest.   }
 {  Output: Dest ->   Pointer to the copied string.                    }
 {*********************************************************************}
function StrECopy(Dest, Source: PChar): PChar;

  {*********************************************************************}
  {  Copies at most MaxLen characters from Source to Dest.              }
  {                                                                     }
  {   Remarks: According to the Turbo Pascal programmer's Reference     }
  {    this routine performs length checking. From the code of the      }
  {    original strings unit, this does not seem true...                }
  {   Furthermore, copying a null string gives two null characters in   }
  {   the destination according to the Turbo Pascal routine.            }
  {*********************************************************************}

function StrLCopy(Dest, Source: PChar; MaxLen: Longint): PChar;

 {*********************************************************************}
 {  Input: Source -> Source of the pascal style string to copy.        }
 {         Dest   -> Destination of null terminated string to copy.    }
 {    Return Value: Dest. (with noew copied string)                    }
 {*********************************************************************}

function StrPCopy(Dest: PChar; Source: String): PChar;

 {*********************************************************************}
 {  Description: Appends a copy of Source to then end of Dest and      }
 {               return Dest.                                          }
 {*********************************************************************}

function StrCat(Dest, Source: PChar): PChar;

 {*********************************************************************}
 { Description: Appends at most MaxLen - StrLen(Dest) characters from  }
 { Source to the end of Dest, and returns Dest.                        }
 {*********************************************************************}

      function strlcat(dest,source : pchar;l : Longint) : pchar;

  {*********************************************************************}
  {  Compares two strings. Does the ASCII value substraction of the     }
  {  first non matching characters                                      }
  {   Returns 0 if both strings are equal                               }
  {   Returns < 0 if Str1 < Str2                                        }
  {   Returns > 0 if Str1 > Str2                                        }
  {*********************************************************************}

function StrComp(Str1, Str2: PChar): Integer;

  {*********************************************************************}
  {  Compares two strings without case sensitivity. See StrComp for more}
  {  information.                                                       }
  {   Returns 0 if both strings are equal                               }
  {   Returns < 0 if Str1 < Str2                                        }
  {   Returns > 0 if Str1 > Str2                                        }
  {*********************************************************************}

function StrIComp(Str1, Str2: PChar): Integer;

  {*********************************************************************}
  {  Compares two strings up to a maximum of MaxLen characters.         }
  {                                                                     }
  {   Returns 0 if both strings are equal                               }
  {   Returns < 0 if Str1 < Str2                                        }
  {   Returns > 0 if Str1 > Str2                                        }
  {*********************************************************************}

function StrLComp(Str1, Str2: PChar; MaxLen: Longint): Integer;

  {*********************************************************************}
  {  Compares two strings up to a maximum of MaxLen characters.         }
  {  The comparison is case insensitive.                                }
  {   Returns 0 if both strings are equal                               }
  {   Returns < 0 if Str1 < Str2                                        }
  {   Returns > 0 if Str1 > Str2                                        }
  {*********************************************************************}

function StrLIComp(Str1, Str2: PChar; MaxLen: Longint): Integer;

 {*********************************************************************}
 {  Input: Str  -> String to search.                                   }
 {         Ch   -> Character to find in Str.                           }
 {  Return Value: Pointer to first occurence of Ch in Str, nil if      }
 {                not found.                                           }
 {  Remark: The null terminator is considered being part of the string }
 {*********************************************************************}

function StrScan(Str: PChar; Ch: Char): PChar;

 {*********************************************************************}
 {  Input: Str  -> String to search.                                   }
 {         Ch   -> Character to find in Str.                           }
 {  Return Value: Pointer to last occurence of Ch in Str, nil if       }
 {                not found.                                           }
 {  Remark: The null terminator is considered being part of the string }
 {*********************************************************************}


function StrRScan(Str: PChar; Ch: Char): PChar;

 {*********************************************************************}
 {  Input: Str1 -> String to search.                                   }
 {         Str2 -> String to match in Str1.                            }
 {  Return Value: Pointer to first occurence of Str2 in Str1, nil if   }
 {                not found.                                           }
 {*********************************************************************}

function StrPos(Str1, Str2: PChar): PChar;

 {*********************************************************************}
 {  Input: Str -> null terminated string to uppercase.                 }
 {  Output:Str -> null terminated string in upper case characters.     }
 {    Return Value: null terminated string in upper case characters.   }
 {  Remarks: Case conversion is dependant on upcase routine.           }
 {*********************************************************************}

function StrUpper(Str: PChar): PChar;

 {*********************************************************************}
 {  Input: Str -> null terminated string to lower case.                }
 {  Output:Str -> null terminated string in lower case characters.     }
 {    Return Value: null terminated string in lower case characters.   }
 {  Remarks: Only converts standard ASCII characters.                  }
 {*********************************************************************}

function StrLower(Str: PChar): PChar;

{ StrPas converts Str to a Pascal style string.                 }

function StrPas(Str: PChar): String;

 {*********************************************************************}
 {  Input: Str  -> String to duplicate.                                }
 {  Return Value: Pointer to the new allocated string. nil if no       }
 {                  string allocated. If Str = nil then return value   }
 {                  will also be nil (in this case, no allocation      }
 {                  occurs). The size allocated is of StrLen(Str)+1    }
 {                  bytes.                                             }
 {*********************************************************************}
function StrNew(P: PChar): PChar;

{ StrDispose disposes a string that was previously allocated    }
{ with StrNew. If Str is NIL, StrDispose does nothing.          }

procedure StrDispose(P: PChar);

Implementation

uses sysutils;


 function strlen(Str : pchar) : Longint;
 Begin
   StrLen:=Sysutils.strlen(str);
 end;



 Function strpas(Str: pchar): string;
 Begin
   strpas:=Sysutils.StrPas(str);
{   SetLength(Result,strlen(str));
   Move(Str^,Result[1],Length(Result));}
 end;

 Function StrEnd(Str: PChar): PChar;
 begin
   StrEnd:=SysUtils.StrEnd(Str);
 end;


 Function StrCopy(Dest, Source:PChar): PChar;
 Begin
   StrCopy:=SysUtils.StrCopy(Dest,Source);
 end;


 function StrCat(Dest,Source: PChar): PChar;
 var
  SourceLength: Longint;
  PEnd: PChar;
 begin
   PEnd := StrEnd(Dest);
   SourceLength:=StrLen(Source);
   move(Source^,Pend^,SourceLength);
   PEnd[SourceLength]:=#0;
   { terminate the string }
   StrCat := Dest;
 end;

 function StrUpper(Str: PChar): PChar;
 begin
   StrUpper:=SysUtils.StrUpper(Str);
 end;

 function StrLower(Str: PChar): PChar;
 begin
   StrLower := Sysutils.StrLower(Str);
 end;


  function StrPos(Str1,Str2: PChar): PChar;
  Begin
   StrPos:=SysUtils.StrPos(Str1,Str2);
  end;


 function StrScan(Str: PChar; Ch: Char): PChar;
  Begin
    Strscan:=SysUtils.StrScan(Str,Ch);
   end;



 function StrRScan(Str: PChar; Ch: Char): PChar;
 Var
  count: Longint;
  index: Longint;
 Begin
   count := Strlen(Str);
   { As in Borland Pascal , if looking for NULL return null }
   if ch = #0 then
   begin
     StrRScan := @(Str[count]);
     exit;
   end;
   Dec(count);
   for index := count downto 0 do
   begin
     if Ch = Str[index] then
      begin
          StrRScan := @(Str[index]);
          exit;
      end;
   end;
   { nothing found. }
   StrRScan := nil;
 end;


 function StrNew(p:PChar): PChar;
      var
         len : Longint;
         tmp : pchar;
      begin
         strnew:=nil;
         if (p=nil) or (p^=#0) then
           exit;
         len:=strlen(p)+1;
         getmem(tmp,len);
         if tmp<>nil then
            move(p^,tmp^,len);
         StrNew := tmp;
      end;


  Function StrECopy(Dest, Source: PChar): PChar;
  Begin
   StrECopy:=Sysutils.StrECopy(Dest,Source);
  end;


   Function StrPCopy(Dest: PChar; Source: String):PChar;
  Begin
   { if empty pascal string  }
   { then setup and exit now }
   if Source = '' then
   Begin
     Dest[0] := #0;
     StrPCopy := Dest;
     exit;
   end;
   Move(Source[1],Dest^,length(Source));
   { terminate the string }
   Dest[length(Source)] := #0;
   StrPCopy:=Dest;
 end;


 procedure strdispose(p : pchar);
 begin
   if p<>nil then
      freemem(p,strlen(p)+1);
 end;


 function strmove(dest,source : pchar;l : Longint) : pchar;
 begin
   move(source^,dest^,l);
   strmove:=dest;
 end;


 function strlcat(dest,source : pchar;l : Longint) : pchar;
 var
   destend : pchar;
 begin
   destend:=strend(dest);
   l:=l-(destend-dest);
   strlcat:=strlcopy(destend,source,l);
 end;


 Function StrLCopy(Dest,Source: PChar; MaxLen: Longint): PChar;
 Begin
   StrLCopy:=Sysutils.StrLCopy(Dest,Source,MaxLen);
 end;


 function StrComp(Str1, Str2 : PChar): Integer;
 begin
   StrComp:=SysUtils.StrComp(Str1,Str2);
 end;
 
     function StrIComp(Str1, Str2 : PChar): Integer;
     Begin
       StrIComp:=Sysutils.StrIComp(Str1,Str2);
     end;


     function StrLComp(Str1, Str2 : PChar; MaxLen: Longint): Integer;
     var
      counter: Longint;
      c1, c2: char;
     Begin
       counter := 0;
       if MaxLen = 0 then
       begin
         StrLComp := 0;
         exit;
       end;
       Repeat
         c1 := str1[counter];
         c2 := str2[counter];
         if (c1 = #0) or (c2 = #0) then break;
         Inc(counter);
      Until (c1 <> c2) or (counter >= MaxLen);
       StrLComp := ord(c1) - ord(c2);
     end;



     function StrLIComp(Str1, Str2 : PChar; MaxLen: Longint): Integer;
     var
      counter: Longint;
      c1, c2: char;
     Begin
       counter := 0;
       if MaxLen = 0 then
       begin
         StrLIComp := 0;
         exit;
       end;
       Repeat
         c1 := upcase(str1[counter]);
         c2 := upcase(str2[counter]);
         if (c1 = #0) or (c2 = #0) then break;
         Inc(counter);
       Until (c1 <> c2) or (counter >= MaxLen);
       StrLIComp := ord(c1) - ord(c2);
     end;
end.
{
  $Log: strings.pas,v $
  Revision 1.8  2008/01/31 04:19:02  carl
   + Delphi Strings unit can support ansistrings

  Revision 1.7  2006/06/17 18:10:15  carl
  + Speed optimisations

  Revision 1.6  2005/11/21 00:17:39  carl
    - remove some compilation warnings/hints
    + speed optimizations

  Revision 1.5  2004/08/19 00:23:37  carl
    + strscan returns nil on a nil pointer parameter

  Revision 1.4  2004/07/05 02:24:31  carl
    - remove some compilation warnings

  Revision 1.3  2004/07/01 22:25:41  carl
    + start of ansistring support

  Revision 1.2  2004/06/17 11:40:58  carl
    - remove some warnings

  Revision 1.1  2004/05/05 16:28:26  carl
    Release 0.95 updates

}
