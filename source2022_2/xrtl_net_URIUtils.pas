unit xrtl_net_URIUtils;

{$INCLUDE xrtl.inc}

interface

function  XRTLURLDecode(const ASrc: WideString): WideString;
function  XRTLURLEncode(const ASrc: WideString): WideString;
function  XRTLURINormalize(const AURI: WideString): WideString;
procedure XRTLURIParse(const AURI: WideString;
                       var VProtocol, VHost, VPath, VDocument, VPort,
                       VBookmark, VUserName, VPassword: WideString);

implementation

uses
  SysUtils;
  //xrtl_util_StrUtils;

function XRTLURLDecode(const ASrc: WideString): WideString;
var
  I: integer;
  ESC: string[2];
  CharCode: integer;
  LSrc: WideString;
begin
  Result:= '';
  LSrc:= StringReplace(ASrc, '+', ' ', [rfReplaceAll]);  {do not localize}
  I:= 1;
  while I <= Length(LSrc) do
  begin
    if LSrc[I] <> '%' then  {do not localize}
    begin
      Result:= Result + LSrc[I];
    end
    else
    begin
      Inc(I); // skip the % char
      ESC:= Copy(LSrc, I, 2); // Copy the escape code
      Inc(I, 1); // Then skip it.
      try
        CharCode:= StrToInt('$' + ESC);  {do not localize}
        if (CharCode > 0) and (CharCode < 256) then
        begin
          Result:= Result + Char(CharCode);
        end;
      except
      end;
    end;
    Inc(I);
  end;
end;

function XRTLURLEncode(const ASrc: WideString): WideString;
const
  UnsafeChars = ['*', '#', '%', '<', '>'];  {do not localize}
var
  I: Integer;
begin
  Result:= '';
  for I:= 1 to Length(ASrc) do
  begin
    if ASrc[I] = ' ' then {do not localize}
    begin
      Result:= Result + '+'; {do not localize}
    end
    else
    begin
      if (Char(ASrc[I]) in UnsafeChars) or (ASrc[I] >= #$80) then
      begin
        Result:= Result + '%' + IntToHex(Ord(ASrc[I]), 2);  {do not localize}
      end
      else
      begin
        Result:= Result + ASrc[I];
      end;
    end;
  end;
end;

function XRTLURINormalize(const AURI: WideString): WideString;
begin
// Normalize the directory delimiters to follow the UNIX syntax
  Result:= StringReplace(AURI, '\', '/', [rfReplaceAll]);
end;

function XRTLFetch(var AInput: WideString; const ADelim: WideString = ' ';
                   const ADelete: Boolean = True): WideString;
var
  LPos: Integer;
  LResult: WideString;
begin
  if ADelim = #0 then
  begin
    // AnsiPos does not work with #0
    LPos:= Pos(ADelim, AInput);
  end
  else
  begin
    LPos:= Pos(ADelim, AInput);
  end;
  if LPos = 0 then
  begin
    LResult:= AInput;
    if ADelete then
    begin
      AInput:= '';
    end;
  end
  else
  begin
    LResult:= Copy(AInput, 1, LPos - 1);
    if ADelete then
    begin
      Delete(AInput, 1, LPos + Length(ADelim) - 1);
    end;
  end;
  // This is necessary to ensure that Result is written last in cases where AInput and Result are
  // assigned to the same variable. Current compilers seem to handle it ok without this, but
  // we cannot safely predict internal workings or future optimizations
  Result:= LResult;
end;



procedure XRTLURIParse(const AURI: WideString;
                       var VProtocol, VHost, VPath, VDocument, VPort,
                       VBookmark, VUserName, VPassword: WideString);
var
  LBuffer: WideString;
  LTokenPos: Integer;
  LURI: WideString;
begin
  LURI:= XRTLURINormalize(AURI);
  VHost:= '';
  VProtocol:= '';
  VPath:= '';
  VDocument:= '';
  //if XRTLPos('://', LURI) > 0 then
  if Pos('://', LURI) > 0 then

  begin
    // absolute URI
    // What to do when data don't match configuration ??
    // Get the protocol
    LTokenPos:= Pos('://', LURI);
    VProtocol:= Copy(LURI, 1, LTokenPos  - 1);
    Delete(LURI, 1, LTokenPos + 2);
    // Get the user name, password, host and the port number
    LBuffer:= XRTLFetch(LURI, '/', True);
    // Get username and password
    LTokenPos:= Pos('@', LURI);
    VPassword := Copy(LBuffer, 1, LTokenPos  - 1);
    if LTokenPos > 0 then
      Delete(LBuffer, 1, LTokenPos + 2);
    VUserName := XRTLFetch(VPassword, ':', True);
    // Ignore cases where there is only password (http://:password@host/pat/doc)
    if Length(VUserName) = 0 then VPassword := '';
    // Get the host and the port number
    VHost := XRTLFetch(LBuffer, ':', True);
    VPort := LBuffer;
    // Get the path
    LTokenPos := Pos('/', LURI);
    VPath := '/' + Copy(LURI, 1, LTokenPos);
    Delete(LURI, 1, LTokenPos);
    // Get the document
    VDocument := LURI;
  end
  else
  begin
    // received an absolute path, not an URI
    // Get the path
    LTokenPos:= Pos('/', LURI);
    VPath := Copy(LURI, 1, LTokenPos);
    Delete(LURI, 1, LTokenPos);
    // Get the document
    VDocument := LURI;
  end;

  VPath := XRTLURLDecode(VPath);
  // Parse the # bookmark from the document
  VBookmark := VDocument;
  VDocument := XRTLURLDecode(XRTLFetch(VBookmark, '#'));
end;

end.
