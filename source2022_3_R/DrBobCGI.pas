unit DrBobCGI;
{===================================================================}
{ DrBobCGI (c) 1999-2002 by Bob Swart (aka Dr.Bob - www.drbob42.com }
{ For the latest version & info see http://www.drbob42.com/DrBobCGI }
{ version 1.0 - obtain standard CGI variable values by "value()".   }
{ version 2.0 - obtain CGI values, cookies and IP/UserAgent values. }
{ version 2.1 - obtain Authorisation values (base64-encoded string) }
{ version 3.0 - ported to Kylix 1.0, still works with Delphi 4+ too }
{               Note: DrBobCGI does not work with Delphi 3 or lower }
{ version 3.1 - combining GET and POST fields inside one Data field }
{ version 3.2 - fix _Value to allow Sep to be a '&' or '; ' string! }
{  for maXbox4.7.1.20 change function name value to bobvalue        }
{===================================================================}
{$IFDEF WIN32}
  {$IFNDEF MSWINDOWS}
    {$DEFINE MSWINDOWS}
  {$ENDIF}
{$ENDIF}
interface
type
  TRequestMethod = (Unknown,Get,Post);
var
  RequestMethod: TRequestMethod = Unknown;

var
  ContentLength: Integer = 0;
  RemoteAddress: String[16] = ''; { IP }
  HttpUserAgent: String[128] = ''; { Browser, OS }
  Authorization: String[255] = ''; { Authorization }
  ScriptName: String[128] = ''; { scriptname URL }

  function bobValue(const Field: ShortString; Convert: Boolean = True): ShortString;
  function CookieValue(const Field: ShortString): ShortString;
  function getCGIEnvValues: string;

implementation
uses
  {$IFDEF MSWINDOWS}
    Windows,
  {$ENDIF}
  {$IFDEF LINUX}
    Libc,
  {$ENDIF}
    SysUtils;

  function _Value(const Field: ShortString;
                  const Data: AnsiString; Sep: String = '&';
                  Convert: Boolean = True): ShortString;
  { 1998/01/02: check for complete match of Field name }
  { 1999/03/01: do conversion *after* searching fields }
  { 2002/06/23: separator can be a '&' or '; ' string! }
  var
    i: Integer;
    Str: String[3];
    len: Byte absolute Result;
  begin
    len := 0; { Result := '' }
    i := Pos(Sep+Field+'=',Data);
    if i = 0 then
    begin
      i := Pos(Field+'=',Data);
      if i > Length(Sep) then i := 0
    end
    else Inc(i,Length(Sep)); { skip Sep }
    if i > 0 then
    begin
      Inc(i,Length(Field)+1);
      while Data[i] <> Sep[1] do
      begin
        Inc(len);
        if (Data[i] = '%') and Convert then // special code
        begin
          Str := '$00';
          Str[2] := Data[i+1];
          Str[3] := Data[i+2];
          Inc(i,2);
          Result[len] := Chr(StrToInt(Str))
        end
        else
          if (Data[i] = ' ') and not Convert then Result[len] := '+'
          else
            Result[len] := Data[i];
        Inc(i)
      end
    end
    else Result := '$' { no javascript }
  end {_Value};

var
  Data: AnsiString = '';

  function bobValue(const Field: ShortString; Convert: Boolean = True): ShortString;
  begin
    Result := _Value(Field, Data, '&', Convert)
  end;

  function getCGIEnvValues: string;
  begin
    result:= inttoStr(ContentLength)+';'+RemoteAddress+';'+HttpUserAgent+';'+
    Authorization+';'+ScriptName+'.'
  end;

var
  Cookie: ShortString;

  function CookieValue(const Field: ShortString): ShortString;
  begin
    Result := _Value(Field, Cookie, '; ');
    if Result = '$' then Result := Cookie { debug }
  end;

var
  P: PChar;
  StartData,i: Integer;
{$IFDEF MSWINDOWS}
  Str: ShortString;
{$ENDIF}

initialization
{$IFDEF MSWINDOWS}
// Tested on IIS and PWS
  P := GetEnvironmentStrings;
  while P^ <> #0 do
  begin
    Str := StrPas(P);
    if Pos('REQUEST_METHOD=',Str) > 0 then
    begin
      Delete(Str,1,Pos('=',Str));
      if Str = 'POST' then RequestMethod := Post
      else
        if Str = 'GET' then RequestMethod := Get
    end;
    if Pos('CONTENT_LENGTH=',Str) = 1 then
    begin
      Delete(Str,1,Pos('=',Str));
      ContentLength := StrToInt(Str)
    end;
    if Pos({HTTP_}'QUERY_STRING=',Str) > 0 then
    begin
      Delete(Str,1,Pos('=',Str));
//    SetLength(Data,Length(Str));
      Data := Str + '&'
    end;
    if Pos({HTTP_}'COOKIE=',Str) > 0 then // TDM #45
    begin
      Delete(Str,1,Pos('=',Str));
//    SetLength(Cookie,Length(Str));
      Cookie := Str + ';'
    end
    else
    if Pos({HTTP_}'REMOTE_ADDR',Str) > 0 then // TDM #39
    begin
      Delete(Str,1,Pos('=',Str));
      RemoteAddress := Str
    end
    else
    if Pos({HTTP_}'USER_AGENT',Str) > 0 then // TDM #39
    begin
      Delete(Str,1,Pos('=',Str));
      if Pos(')',Str) > 0 then
        Delete(Str,Pos(')',Str)+1,Length(Str)); {!!}
      HttpUserAgent := Str
    end
    else
    if (Pos({HTTP_}'AUTHORIZATION',Str) > 0) then // TDM #55
    begin
      Delete(Str,1,Pos('=',Str));
      Authorization := Str;
    end
    else
    if Pos({HTTP_}'SCRIPT_NAME',Str) > 0 then // TDM #71
    begin
      Delete(Str,1,Pos('=',Str));
      ScriptName := Str
    end;
    Inc(P, StrLen(P)+1)
  end;
{$ENDIF}
{$IFDEF LINUX}
// Tested on Apache for Linux
  P := getenv('REQUEST_METHOD');
  if P = 'POST' then RequestMethod := Post
  else
    if P = 'GET' then RequestMethod := Get;
  ContentLength := StrToIntDef(getenv('CONTENT_LENGTH'),0);
  Data := getenv('HTTP_QUERY_STRING');
  if Data = '' then
    Data := getenv('QUERY_STRING');
  if Data <> '' then Data := Data + '&';
  Cookie := StrPas(getenv('HTTP_COOKIE'));
  if Cookie = '' then
    Cookie := StrPas(getenv('COOKIE'));
  RemoteAddress := StrPas(getenv('HTTP_REMOTE_ADDR'));
  if RemoteAddress = '' then
    RemoteAddress := StrPas(getenv('REMOTE_ADDR'));
  HttpUserAgent := StrPas(getenv('HTTP_USER_AGENT'));
  if HttpUserAgent = '' then
    HttpUserAgent := StrPas(getenv('USER_AGENT'));
  Authorization := StrPas(getenv('HTTP_AUTHORIZATION'));
  if Authorization = '' then
    Authorization := StrPas(getenv('AUTHORIZATION'));
  ScriptName := StrPas(getenv('SCRIPT_NAME'));
{$ENDIF}
  if RequestMethod = Post then
  begin
    StartData := Length(Data);
    SetLength(Data,StartData+ContentLength+1);
    for i:=1 to ContentLength do read(Data[StartData+i]);
    Data[StartData+ContentLength+1] := '&';
  { if IOResult <> 0 then { skip }
  end;
  i := 0;
  while i < Length(Data) do
  begin
    Inc(i);
    if Data[i] = '+' then Data[i] := ' '
  end;
  if i > 0 then Data[i+1] := '&'
           else Data := '&';
finalization
  Cookie := '';
  Data := ''
end.
