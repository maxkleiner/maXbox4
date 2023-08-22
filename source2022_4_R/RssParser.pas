unit RssParser;

interface

uses
  RssModel, SysUtils;


type
  ERSSParserException = class(Exception);

  IRSSParser = interface
    ['{263159EC-F94D-4BA6-9D34-5D93277D4DDC}']
    function ParseRSSFeed(XML: string): TRSSFeed;
  end;

var
  DefaultRSSParser: IRSSParser = nil;



function ParseRSSDate(DateStr: string): TDateTime;
function ParseRSSFeed(XML: string): TRSSFeed;

implementation

uses
  XMLDoc, XMLIntf, Windows;

function FetchNextToken(var s: string; space: string = ' '): string;
var
  SpacePos: Integer;
begin
  SpacePos := Pos(space, s);
  if SpacePos = 0 then
  begin
    Result := s;
    s := '';
  end
  else
  begin
    Result := Copy(s, 1, SpacePos - 1);
    Delete(s, 1, SpacePos);
  end;
end;

function MonthToInt(MonthStr: string): Integer;
const
  Months: array [1..12] of string = ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
    'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
var
  M: Integer;
begin
  for M := 1 to 12 do
    if Months[M] = MonthStr then begin
      result:= M;
      Exit;
    end;
  raise Exception.CreateFmt('Unknown month: %s', [MonthStr]);
end;

function ParseRSSDate(DateStr: string): TDateTime;
var
  df: TFormatSettings;
  Day, Month, Year, Hour, Minute, Second: Integer;
begin
  // Parsing date in this format: Mon, 06 Sep 2009 16:45:00 +0000
  FetchNextToken(DateStr);                          // Ignore "Mon, "
  Day := StrToInt(FetchNextToken(DateStr));         // "06"
  Month := MonthToInt(FetchNextToken(DateStr));     // "Sep"
  Year := StrToInt(FetchNextToken(DateStr));        // "2009"
  Hour := StrToInt(FetchNextToken(DateStr, ':'));   // "16"
  Minute := StrToInt(FetchNextToken(DateStr, ':')); // "45"
  Second := StrToInt(FetchNextToken(DateStr));      // "00"
  Result := EncodeDate(Year, Month, Day) + EncodeTime(Hour, Minute, Second, 0);
end;

function ParseRSSFeed(XML: string): TRSSFeed;
var
  Doc: IXMLDocument;
  ChannelNode, Node: IXMLNode;
  RssItem: TRSSItem;
begin
  Doc := LoadXMLData(XML);
  Doc.Active := True;
  ChannelNode := Doc.DocumentElement.ChildNodes.First;

  Result := TRSSFeed.Create;

  Node := ChannelNode.ChildNodes.First;
  while Node <> nil do
  begin
    // Some feeds have atom:link element and other similar. We are only looking
    // for elements without namespace
    if Node.NamespaceURI = '' then
    begin
      if Node.NodeName = 'title' then
        Result.Title := Node.Text
      else
      if Node.NodeName = 'link' then
        Result.Link := Node.Text
      else
      if Node.NodeName = 'description' then
        Result.Description := Node.Text
      else
      if Node.NodeName = 'item' then
      begin
        RssItem := Result.AddItem;
        RssItem.Title := Node.ChildNodes['title'].Text;
        RssItem.Link := Node.ChildNodes['link'].Text;
        RssItem.Description := Node.ChildNodes['description'].Text;
        RssItem.PubDate := ParseRSSDate(Node.ChildNodes['pubDate'].Text);
      end;
    end;
    Node := Node.NextSibling;
  end;
end;

end.
