unit XmlDocRssParser;

interface

uses
  RssParser, RssModel;

type
  TXmlDocRssParser = class(TInterfacedObject, IRSSParser)
  public
    function ParseRSSDate(DateStr: string): TDateTime;
    function ParseRSSFeed(XML: string): TRSSFeed;
  end;

implementation

uses
  XMLDoc, XMLIntf, Windows, Classes, SysUtils;

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
      //xit(M);
      result:= M;
      Exit;
    end;
  raise ERSSParserException.CreateFmt('Unknown month: %s', [MonthStr]);
end;

{ TXmlDocRssParser }

function TXmlDocRssParser.ParseRSSDate(DateStr: string): TDateTime;
var
  df: TFormatSettings;
  s: string;
  Day, Month, Year, Hour, Minute, Second: Integer;
begin
  s := DateStr;
  // Parsing date in this format: Mon, 06 Sep 2009 16:45:00 +0000
  try
    FetchNextToken(s);                          // Ignore "Mon, "
    Day := StrToInt(FetchNextToken(s));         // "06"
    Month := MonthToInt(FetchNextToken(s));     // "Sep"
    Year := StrToInt(FetchNextToken(s));        // "2009"
    Hour := StrToInt(FetchNextToken(s, ':'));   // "16"
    Minute := StrToInt(FetchNextToken(s, ':')); // "45"
    Second := StrToInt(FetchNextToken(s));      // "00"
    Result := EncodeDate(Year, Month, Day) + EncodeTime(Hour, Minute, Second, 0);
  except
    on E: Exception do
      raise ERSSParserException.CreateFmt('Can''t parse date "%s": %s',
        [DateStr, E.Message]);
  end;
end;

function TXmlDocRssParser.ParseRSSFeed(XML: string): TRSSFeed;
var
  Doc: IXMLDocument;
  ChannelNode, Node: IXMLNode;
  RssItem: TRSSItem;
begin
  Result := nil;
  try
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
  except
    on E: Exception do
    begin
      if Result <> nil then
        Result.Free;
      raise ERSSParserException.CreateFmt('Failed to parse RSS: %s',
        [E.Message]);
    end;
  end;
end;

end.
