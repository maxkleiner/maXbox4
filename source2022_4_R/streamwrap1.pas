{ Some useful stream functions.

  Included so far:
   -some functions to convert streams into strings and vice versa.

  Author: Lars aka L505
         http://z505.com }


unit StreamWrap1;

{$ifdef fpc} {$mode objfpc}{$H+}{$endif}

interface

uses
  Classes;

{Global functions...}
 procedure StrToStream(s:String; strm:TMemoryStream);
 function StrLoadStream(strm:TStream):String;


{*************************************************************************}
implementation
{*************************************************************************}


{ Converts a string to a stream.
  Also known as StrSaveToStream, StringSaveToStream, Str2Stream, String2Stream}
procedure StrToStream(s:String;strm:TMemoryStream);
begin
  strm.Write(s[1],Length(s));
end;

{ Converts a stream to a string.
  Also known as StrLoadFromStream, StringLoadFromString  StreamToString,
  Stream2String, Stream2Str}
function StrLoadStream(strm:TStream):String;
begin
  SetLength(Result,strm.Size);
  strm.Position := 0;
  strm.Read(Result[1],strm.Size);
end;


end.

