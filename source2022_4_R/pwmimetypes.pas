{ *****************************************************************************
   Powtils mimetype unit
   Started 08-Mar-2006 by Anthony W. Henry
  *****************************************************************************

 Apr-29-2007 -L505
  Tony, I moved initialization into InitMimeDb() procedure. Initialization is
  not smartlinked and bloats up the  CGI program. Also WTF are those GOTOs :^| 
  
  DOC NOTES: If a mime type database goes out of date people can use 
  SetWebHeader() manually with webBufferOut or a TStream class loaded 
  into memory and set their mime types to thier own. 

}
unit pwmimetypes;

{$IFDEF FPC}{$MODE OBJFPC}{$H+}{$GOTO ON}{$ENDIF}
{$IFDEF WIN32} {$DEFINE WINDOWS} {$ENDIF} 
{$IFNDEF FPC}{$DEFINE SYSUTILS_ON}{$ENDIF}

interface

{$IFDEF WINDOWS}uses windows;{$ENDIF}

{$IFNDEF FPC}type PtrUInt = DWORD;{$ENDIF}

// Useful Sets Of Characters.
// definition of PWU_WHITESPACE and PWU_ENDLINE
// are in here
{$I charsets.inc}

// *** Constants
const
   MIME_OK = 0;
   MIME_CANTFIND_DATABASE = 1;
   MIME_ERR_FILEIO = 2;
   MIME_FOUND = 3;
   MIME_NOT_FOUND = 4;
   DefaultMimeType = 'application/octet-stream';

function GetMimeType(CONST MimeFile : string) : String;
function MimeStatus : Integer;
procedure InitMimeDb;


implementation

uses 
  {$ifdef SYSUTILS_ON}sysutils,{$else}CompactSysUtils,{$endif}
  {$ifdef UNIX}baseunix,{$endif} 
  {$ifndef fpc}strutils,{$endif}
  pwsubstr, pwfileutil;

 
CONST
  {$IFDEF WINDOWS}UpOneDir = '..\';{$ENDIF}
  {$IFDEF UNIX}   UpOneDir = '../';
                  ConfigDir = '/etc/';
  {$ENDIF}     

Type 
  TGetline = function : String;
  TCleanup = procedure; 
  
Var
  GetNextLine : TGetline;
  Mime_Stat_Int : Integer;
  CleanUpDataBase : TCleanup;
  MimeTxt : Text;
  MimeDataFile: string;
  BuffHead,
  BuffCh: ^Char;
  BuffSize: LongInt;
  {$IFDEF WINDOWS}ConfigDir: string;{$ENDIF}
  LastMimeLine: Boolean;
  
  
function MimeStatus : Integer;
begin
  result := Mime_Stat_Int;
  case Mime_Stat_Int of
    MIME_FOUND : Mime_Stat_Int := MIME_OK;
    MIME_NOT_FOUND : Mime_Stat_Int := MIME_OK;
  end;
end;      

 
procedure FindMimeDataBase;
const mfilename = 'pwu_mime.types';
var
  WorkName: string;
 {$IFDEF WINDOWS} ename: string;{$ENDIF} 
begin
  Mime_Stat_Int := MIME_OK;
  WorkName := mfilename;
  
  If FileExists_read(WorkName) then 
     { null }
  else
    begin   
     WorkName := UpOneDir + WorkName;
     If FileExists_read(WorkName) then 
        { null }
     else 
       begin   
        {$IFDEF WINDOWS}
         SetLength(ConfigDir, 100);
         ename := 'WINDIR' + #0;
         SetLength(ConfigDir, 
         windows.GetEnvironmentVariable(@ename[1], @ConfigDir[1],Length(ConfigDir)));
         ConfigDir := ConfigDir + '\';
        {$ENDIF}   
        { ConfigDir is defined as Const = '/etc/' in Unix **}
        WorkName := ConfigDir + mfilename;
        If FileExists_read(WorkName) then 
          { null }
        else 
          Mime_Stat_Int := MIME_CANTFIND_DATABASE;
     end;    
   end;  
   // ** Set name that is Global to Unit
   MimeDataFile := WorkName;
end;   


// *** 2 Clean Up procedures
// *** One of the 2 will be called by
// *** CleanupDatabase procedural Variable
procedure CleanUpMimeBuffer;
begin
 FreeMem(BuffHead);
 LastMimeLine := FALSE;
end; 

procedure CloseMimeTextFile;
begin
 Close(MimeTxt);
 LastMimeLine := FALSE;
end; 


// ** This variable is here so it is persistent;
Var
 BuffCtr : LongInt;

// *** This function grabs lines from the Memory
// *** Buffer.   
function GetNextLineFromBuffer : String;
label
 start;
var
 tmp : String;
 SSize,SCtr : LongInt;
 
begin
Start:
 tmp := '';
 // Skip any End Of Line Characters or PWU_WHITESPACE we are in.
 While (BuffCh^ in PWU_WHITESPACE) and (NOT LastMimeLine) do
   begin
     Inc(PtrUInt(BuffCh));
     Inc(BuffCtr);
     If BuffCtr = BuffSize then LastMimeLine := TRUE;
   end;
   
// Not at the end   
 if NOT LastMimeLine THEN 
   begin  
    SCtr := 0; SSize := 80;
    SetLength(tmp,80);
    Repeat
     tmp[SCtr + 1] := BuffCh^;
     Inc(PtrUInt(BuffCh));
     Inc(SCtr);
     Inc(BuffCtr);
     If BuffCtr >= BuffSize then LastMimeLine := TRUE;
     If SCtr > SSize THEN 
        begin
          SSize := SSize + 50;
          SetLength(tmp, SSize);
        end;
    Until (BuffCh^ in PWU_ENDLINE) or LastMimeLine;
    SetLength(tmp, SCtr);
    tmp := strtrim(tmp);
    // *** Automatically skip unnecessary
    // *** Lines 
    If NOT LastMimeLine then
       If (tmp = '') or (tmp[1] = '#') then goto Start;  // Ignore Remarks or Blank Lines.
   end; 
 Result := tmp;
end;

// *** No buffer so use readln
// *** Just a little extra logic to
// *** trim PWU_WHITESPACE and automatically
// *** skip unneeded lines
function GetNextLineFromFile : String;
label
 Start;
var
 tmp : String;
begin
Start:
  If Not EOF(MimeTxt) then
    begin
     Readln(MimeTxt, tmp);
     // ** str_trim gives memory access error on 0 length
     // ** do not need to trim 0 length anyway. 
     If length(tmp) > 0 then tmp  := strtrim(tmp);
     // *** Disregard remarks and empty strings.
     If (tmp = '') or (tmp[1] = '#') then goto Start;
    end; 
  LastMimeLine := EOF(MimeTxt);
  Result := tmp;
end;


procedure OpenMimeDataBase;
var
  MimeBlk: File;
  FSize,
  NumRead: LongInt;
  Done : Boolean;
begin
  Done := FALSE;
  Assign(MimeBlk, MimeDataFile);
 {$I-} 
  Reset(MimeBlk, 1);
  If IOResult <> 0 then
     begin
       Close(MimeBlk);
       Mime_Stat_Int := MIME_ERR_FILEIO;
       Exit;
     end;  
  {$I+}   
  FSize := FileSize(MimeBlk);
  BuffHead := NIL;
  NumRead:= 0;
  GetMem(BuffHead, FSize);
  If BuffHead <> NIL THEN
     begin
      BuffCh := BuffHead;
     {$I-}
       BlockRead(MimeBlk, BuffHead^, FSize, NumRead);
     {$I+}
      If IOResult <> 0 then
           begin
             Close(MimeBlk);
             Mime_Stat_Int := MIME_ERR_FILEIO;
             Exit;
           end;  
       If FSize = NumRead then Done := True;
       BuffSize := FSize;
       BuffCtr := 1;
       Close(MimeBlk);
     end
  else Close(MimeBlk);
  Assign(MimeBlk,'');
  If Done THEN
     begin
       GetNextLine := @GetNextLineFromBuffer;
       CleanupDataBase := @CleanupMimeBuffer;
     end
  else
     begin
       Assign(MimeTxt, MimeDataFile);
       {$I-}
        Reset(MimeTxt);
        If IOResult <> 0 then
           begin
             Close(MimeTxt);
             Mime_Stat_Int := MIME_ERR_FILEIO;
             Exit;
           end;  
       {$I+}   
       GetNextLine := @GetNextLineFromFile;
       CleanupDataBase := @CloseMimeTextFile;
     end;
end;       
           
      
function GetMimeType(CONST MimeFile : String) : String;
label
 DoTest;

Var
 FExtension,
 Test,
 MType : String;
 GotMType, 
 TestBegin,
 TestEnd : Boolean;
 SPos,FLen : LongInt;
 
begin
  InitMimeDb;
  result:= DefaultMimeType;
  GotMType := False;
  FExtension := ExtractFileExt(MimeFile);
  If (FExtension = '') or (FExtension = '.')  then exit;
  Delete(FExtension,1,1);  // Delete . 
  FLen := Length(FExtension);
  OpenMimeDataBase;
  If Mime_Stat_Int <> MIME_OK then exit;
  While (NOT GotMType) and (NOT LastMimeLine) do
    begin
      MType := '';
      Test := GetNextLine();
      Spos := 0;
      If Length(Test) = 0 then continue;
      While (Spos < Length(Test)) and (NOT (Test[Spos] in PWU_WHITESPACE)) do
           Inc(SPos);     
      // *** If theres no PWU_WHITESPACE or the PWU_WHITESPACE characters are at the
      // *** end of the string  then theres no extensions for this entry
      // *** nothing to test so continue    
      If (SPos = 0) or (Spos = Length(Test)) then Continue;    
      // ** The mime_type is the left part of the string
      // ** So store it in MType
      MType := LeftStr(Test, SPos-1);
      // ** Now get rid of it
      Delete(Test,1, SPos);
  DoTest:      
      // *** Testing for presence of extension case insensitive
      // *** so HTML matchs html, GIF matches gif etc.......
      SPos := SubstriPos(Test, FExtension);
      If SPos > 0 then 
         begin
          // *** Make sure html does not match xhtml ....
          // *** by checking for adjacent characters.
          // *** extension found can either be at either end of string
          // *** or be bordered by PWU_WHITESPACE.
          TestBegin := (Spos = 1) or (Test[Spos-1] in PWU_WHITESPACE);
          TestEnd := ((Spos + FLen) >= Length(Test)) or (Test[SPos + Flen] in PWU_WHITESPACE);
          // *** BOTH tests must be true.
          GotMType := TestBegin AND TestEnd;  
          If NOT GotMType THEN
             begin
              // *** We are here because we got a match that did not
              // *** Test out.  For example ps would initially match eps
              // *** buf the ends test would fail because of (e) on beginning
              // *** We might still have the correct line so delete
              // *** what we tested first and try again. 
              Delete(Test,SPos, Flen);
              Goto DoTest;
             end; 
         end;
    end;

  // *** Clean Up the mess. 
  CleanUpDataBase;
    
  If GotMType then 
  begin
    Mime_Stat_Int := MIME_FOUND;
    Result := MType; 
  end else
  begin
   // ** Set to Default but clue CGI program
   // ** That we do not have a database entry.
    Mime_Stat_Int := MIME_NOT_FOUND;
    Result := DefaultMimeType;         
  end;  
end;  

{ call this  to make sure we have mime types text file DataBase }
procedure InitMimeDb;
begin
  FindMimeDataBase;
  LastMimeLine := FALSE;
end;

initialization
{ MOVED CODE TO InitMimeDB - Tony, I don't like all the global initialization 
  and  global variables used in this unit -L505 }
end.  
