unit synwrap1; {$IFDEF fpc} {$MODE objfpc}{$H+} {$ENDIF}

{ Version: September 15, 2006
  Wrapper unit for synapse which handles redirects.

--------------------------------------------------------------------------------
  THIS UNIT REQUIRES:
    -Synapse Library. Download Synapse from internet (i.e. httpsend unit)
    -StreamWrap1 should be in the same zip file as this unit was in

  THIS UNIT WAS ONLY TESTED with FPC 2.0.2 and Delphi 5 but it should work with
  similar compilers.
--------------------------------------------------------------------------------

  PURPOSE:  This unit shows extremely simple 301,302,307 and similar redirection 
            recursion Synapse does not handle as of current writing (Indy has 
            supported redirects for ages and synapse needs this functionality,
  NOTE:
      I don't feel like inheriting the big synapse class and making
      my own abstracted synapse class with redirection because:
        A) object oriented code is too complex for what I need
        B) synapse class might change at some point and break the abstracted inherited hackery jobs
        C) I need something simple
        D) I need something really really simple, just want to GET URL!

  Note: if there is another error unrelated to 301, 302, and 307.. such as 404
        or 403, you get that error and you should get the HTML page with
        that error on it. So like in a web browser, you still get (visit) the
        error page first and then get redirected to the final page. See the
        demo programs on how to display the final page HTML.

  Author: Lars aka L505
          http://z505.com }

interface

uses
  StreamWrap1, //some useful stream functions
  httpsend, {Synapse unit for misc http functions}
  sysutils, {for StringReplace}
  strutils, {for FindPart}
  classes;


type
  TSynwInfo = record
      Err        : byte;        // general err feedback
      UrlHtml    : ansistring;  // received html
      ErrResponse: integer;     // HTTP Error returned, such as 404
      UltimateURL: ansistring;  // ultimate location returned if a 301 response. So if you requested url yahoo.com and you GOT www.yahoo.com in the end, you are notified that you got www.yahoo.com
      Headers    : ansistring;
  end;

 {Err feedback
     0: DOMAIN ACTIVE (could be error OR SUCCESS, such as 404, 200)
     1: NETWORK ERROR or DOMAIN DOES NOT EXIST
     2: COULD NOT FIND REDIRECT LOCATION FROM HEADER
     3: FUNCTION DID NOT FINISH OR CRASHED}
type
  TUrlInfo = record
    Err: byte; // error code if function not successful
    UltimateURL: string;
  end;



{ public functions...}

function GetHttpFile(const Url, UserAgent, Outfile: string; verbose: boolean): TSynwInfo; overload;
function GetHttpFile(const Url, UserAgent, Outfile: string): TSynwInfo; overload;
function GetHttpFile(const Url, Outfile: string): TSynwInfo; overload;
function GetHttpFile(const Url, outfile: string; verbose: boolean): TSynwInfo; overload;

function GetHtm(const Url: string): string; overload;
function GetHtm(const Url, UserAgent: string): string; overload;

function GetUrl(const Url: string; verbose: boolean): TSynwInfo; overload;
function GetUrl(const Url, useragent: string): TSynwInfo; overload;
function GetUrl(const Url: string): TSynwInfo; overload;
function GetUrl(const Url: string; const http: THTTPSend; verbose: boolean): TUrlInfo; overload;
function GetUrl(const Url: string; const http: THTTPSend): TUrlInfo; overload;
function GetUrlX(const Url: string; verbose: boolean): TSynwInfo; //overload;


var
  ErrOut: procedure(s: string); // error reporting procedure

implementation

const DEFAULT_USER_AGENT = 'synwrap1';


function FindPart(const HelpWilds, inputStr: string): Integer;
var
i, J: Integer;
Diff: Integer;
begin
Result:=0;
i:=Pos('?',HelpWilds);
if (i=0) then
Result:=Pos(HelpWilds, inputStr)
else
begin
Diff:=Length(inputStr) - Length(HelpWilds);
for i:=0 to Diff do
begin
for J:=1 to Length(HelpWilds) do
if (inputStr[i + J] = HelpWilds[J]) or (HelpWilds[J] = '?') then
begin
if (J=Length(HelpWilds)) then
begin
Result:=i+1;
Exit;
end;
end
else
Break;
end;
end;
end;

{ private function to find 'Location:' in redirect error header...}
function FoundLocationStr(headers: TStringlist; out FoundPos: integer): integer;
var i: integer;
begin
  result:= -1;  //for safety
 {find the line "Location:" is on...}
  for i:= 0 to Headers.Count do
  begin
    FoundPos:= FindPart('Location: ', Headers.Strings[i]);
    if FoundPos > 0 then //has to be above 0 otherwise nothing was found
    begin
      result:= i; //return the line number that "Location: " is on
      exit; //exit this function only the first time that iLoc is > 0
    end;
  end;
end;

{ simply returns content as a file, automatically handles redirects }
function GetHttpFile(const Url, UserAgent, outfile: string; verbose: boolean): TSynwInfo; overload;
var
  HTTP        : THTTPSend;
  FoundStrPos : integer;     //if string is found, return position
  FoundLine   : integer;     //if string is found, return line it is on
begin
    // initialize
   result.UltimateURL:= url;
   result.err:= 3; // general default error

   HTTP:= THTTPSend.Create;
   try
     HTTP.UserAgent:= useragent;
   {..If Getting the URL went bad... (site is dead or domain doesn't exist)...}
     if not HTTP.HTTPMethod('GET', Url) then
     begin
       result.ErrResponse:= Http.Resultcode; //RETURN the HTTP error code
       result.err:= 1;   //General error code feedback
       result.Headers:= http.Headers.Text;
     end else
   {..But If Getting the URL went good........................................}
     begin
       result.ErrResponse:= Http.Resultcode; //RETURN the HTTP error, i.e. 404, 500, 200, etc.
       if verbose then //if verbose reporting, then display info about each redirection attempt
       begin
         ErrOut(inttostr(result.ErrResponse) + ' ' + Http.Resultstring);
         ErrOut('');
         ErrOut(Http.Headers.text);
         ErrOut('');
       end;

       Http.Document.SaveToFile(outfile); //convert memory stream to file
       result.err:= 0; //successful
       result.Headers:= http.Headers.Text;
          { if 3XX redirection error, get the URL at it's new location given to us from the server header}
       case Http.Resultcode of
         301, 302, 307:
         begin
           FoundStrPos:= 0;
           FoundLine:= FoundLocationStr(http.Headers, FoundStrPos);
           if (FoundLine >= 0) and (FoundLine<=Http.Headers.count) then
           begin
             result.UltimateURL:= //RETURN the new url to redirect to
               StringReplace(Http.Headers.Strings[FoundLine],'Location: ','',[]); //strip the line with 'Location: http: someurl.com' down to JUST the URL
            {!recursively! call this function again, UNTIL we eventually get to the new URL location...(even if they redirect us 1 or more times)}
             result:= GetHttpFile(result.UltimateURL, UserAgent, OutFile, verbose);
           end else
             result.err:= 2; //couldn't find redirect URL Location in header
         end;
       end;
     end;

   finally
     HTTP.Free;
   end; { OF TRY }
end; { OF FUNCTION }

// simpler overloaded
function GetHttpFile(const Url, outfile: string): TSynwInfo; overload;
begin
  result:= GetHttpFile(Url, DEFAULT_USER_AGENT, outfile, false);
end;

// simpler overloaded with verbose option
function GetHttpFile(const Url, outfile: string; verbose: boolean): TSynwInfo; overload;
begin
  result:= GetHttpFile(Url, DEFAULT_USER_AGENT, outfile, verbose);
end;

// simpler overloaded with useragent option
function GetHttpFile(const Url, UserAgent, Outfile: string): TSynwInfo; overload;
begin
  result:= GetHttpFile(Url, useragent, outfile, false);
end;

{ This function automatically handles redirects for getting a URL with synapse
  TSynwInfo record is used to store page text, errors, ultimate url and more
  information after the page has redirected to its final location}
function GetUrl(const Url: string; useragent: string; verbose: boolean): TSynwInfo; overload;
  var
    HTTP        : THTTPSend;
    FoundStrPos : integer;     //if string is found, return position
    FoundLine   : integer;     //if string is found, return line it is on

  {local function to find 'Location:' in redirect error header...}
  function FoundLocStr:integer;
  var
    iLoc   : integer;     //local loop integer
  begin
    result:= -1;  //for safety
   {find the line "Location:" is on...}
    for iLoc:= 0 to Http.Headers.Count do
    begin
      FoundStrPos:= FindPart('Location: ',Http.Headers.Strings[iLoc]);
      if FoundStrPos > 0 then //has to be above 0 otherwise nothing was found
      begin
        result:= iLoc; //return the line number that "Location: " is on
        exit; //exit this function only the first time that iLoc is > 0
      end;
    end;
  end;

begin
    // initialize
   result.UltimateURL:= url;
   result.URLHtml:= '';
   result.err:= 3; // general default error

   HTTP:= THTTPSend.Create;
   try
     HTTP.UserAgent:= useragent;
   {..If Getting the URL went bad... (site is dead or domain doesn't exist)...}
     if not HTTP.HTTPMethod('GET', Url) then
     begin
       result.ErrResponse:= Http.Resultcode; //RETURN the HTTP error code
       result.err:= 1;   //General error code feedback
       result.UrlHtml:= '';   //return no html
       result.Headers:= http.Headers.Text;
     end else
   {..But If Getting the URL went good........................................}
     begin
       result.ErrResponse:= Http.Resultcode; //RETURN the HTTP error, i.e. 404, 500, 200, etc.
       if verbose then //if verbose reporting, then display info about each redirection attempt
       begin
         ErrOut(inttostr(result.ErrResponse) + ' ' + Http.Resultstring);
         ErrOut('');
         ErrOut(Http.Headers.text);
         ErrOut('');
       end;

       result.UrlHtml:= StrLoadStream(Http.Document); //convert memory stream to string, and return that string.
       result.err:= 0; //successful
       result.Headers:= http.Headers.Text;
          { if 3XX redirection error, get the URL at it's new location given to us from the server header}
       case Http.Resultcode of
         301, 302, 307:
         begin
           FoundLine:=FoundLocStr;
           if (FoundLine >= 0) and (FoundLine<=Http.Headers.count) then
           begin
             result.UltimateURL:= //RETURN the new url to redirect to
               StringReplace(Http.Headers.Strings[FoundLine],'Location: ','',[]); //strip the line with 'Location: http: someurl.com' down to JUST the URL
            {!recursively! call this function again, UNTIL we eventually get to the new URL location...(even if they redirect us 1 or more times)}
             result:= GetUrl(result.UltimateURL, verbose);
           end else
             result.err:= 2; //couldn't find redirect URL Location in header
         end;
       end;
     end;

   finally
     HTTP.Free;
   end; { OF TRY }
end; { OF FUNCTION }

// simpler version of the above function
function GetUrl(const Url: string): TSynwInfo; overload;
begin
  result:= GetUrl(Url, false);
end;

function GetUrlX(const Url: string; verbose: boolean): TSynwInfo; //overload;
begin
  result:= GetUrl(Url, verbose);
end;

// alternative
function GetUrl(const Url: string; verbose: boolean): TSynwInfo; overload;
begin
  result:= GetUrl(Url, DEFAULT_USER_AGENT, verbose);
end;

// alternative
function GetUrl(const Url, useragent: string): TSynwInfo; overload;
begin
  result:= GetUrl(Url, useragent, false);
end;

{ simpler, get HTML for a url, automatically handles redirects }
function GetHtm(const Url: string): string; overload;
var
  si: TSynwInfo;
begin
  si:= GetUrl(Url);
  result:= si.UrlHtml
end;

{ simpler, get HTML with user agent option, automatically handles redirects  }
function GetHtm(const Url, UserAgent: string): string; overload;
var
  si: TSynwInfo;
begin
  si:= GetUrl(Url, useragent);
  result:= si.UrlHtml
end;

{ This function is similar to the above functions but one can  pass his own
  synapse THTTPSend class, with more control over synapse class  before and
  after function execution }
function GetUrl(const Url: string; const http: THTTPSend; verbose: boolean): TUrlInfo; overload;
  var
    FoundStrPos : integer;     //if string is found, return position
    FoundLine   : integer;     //if string is found, return line it is on

  {sub function to find 'Location:' in redirect error header...}
  function FoundLocStr:integer;
  var
    iLoc   : integer;     //local loop integer
  begin
    result:= -1;  //for safety
   {find the line "Location:" is on...}
    for iLoc:= 0 to Http.Headers.Count do
    begin
      FoundStrPos:= FindPart('Location: ',Http.Headers.Strings[iLoc]);
      if FoundStrPos > 0 then //has to be above 0 otherwise nothing was found
      begin
        result:= iLoc; //return the line number that "Location: " is on
        exit; //exit this function only the first time that iLoc is > 0
      end;
    end;
  end;

begin
    // initialize
    if http = nil then exit;
    http.Clear;
    result.Err:= 3; // general default error
    result.UltimateURL:= url;

  {..If Getting URL went bad... (site dead or domain doesn't exist)...}
    if not HTTP.HTTPMethod('GET', URL) then
    begin
      result.Err:= 1;   //General error code feedback
      exit;
    end else
  {..But If Getting URL went good........................................}
    begin
      if verbose then //if verbose reporting, then display each and every information about each redirection attempt
      begin
        ErrOut(inttostr(http.ResultCode) + ' ' + Http.Resultstring);
        ErrOut('');
        ErrOut(Http.Headers.text);
        ErrOut('');
      end;

      result.err:= 0; //successful

      { if 3XX redirection error, get the URL at it's new location given to us from the server header}
      case Http.Resultcode of
        301, 302, 307:
        begin
          FoundLine:= FoundLocStr;
          if (FoundLine >= 0) and (FoundLine<=Http.Headers.count) then
          begin
            result.UltimateURL:= //RETURN the new url to redirect to
                       StringReplace(Http.Headers.Strings[FoundLine],'Location: ','',[]); //strip the line with 'Location: http: someurl.com' down to JUST the URL
           {!recursively! call this function again, UNTIL we eventually get to the new URL location...(even if they redirect us 1 or more times)}
            result:= GetUrl(result.UltimateURL, http, verbose);
          end else
            result.err:= 2; //couldn't find redirect URL Location in header
        end;
      end;

    end;
end; { OF FUNCTION }

// simpler
function GetUrl(const Url: string; const http: THTTPSend): TUrlInfo; overload;
begin
  result:= GetUrl(Url, http, false);
end;


end.

