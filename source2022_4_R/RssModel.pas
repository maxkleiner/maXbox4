unit RssModel;

interface

uses
  //Collections;
  contnrs;

type
  TRSSItem = class
  private
    FPubDate: TDateTime;
    FLink: string;
    FTitle: string;
    FDescription: string;
  public
    property Title: string read FTitle write FTitle;
    property Link: string read FLink write FLink;
    property Description: string read FDescription write FDescription;
    property PubDate: TDatetime read FPubDate write FPubDate;
  end;

  TRSSFeed = class
  private
    FDescription: string;
    FTitle: string;
    FLink: string;
    FItems: TObjectList; //<TRSSItem>;
  public
    constructor Create;
    destructor Destroy; override;

    function AddItem: TRSSItem;

    property Title: string read FTitle write FTitle;
    property Description: string read FDescription write FDescription;
    property Link: string read FLink write FLink;
    property Items: TObjectList {<TRSSItem>} read FItems;
  end;

implementation

{ TRSSFeed }

function TRSSFeed.AddItem: TRSSItem;
begin
  Result := TRSSItem.Create;
  FItems.Add(Result);
end;

constructor TRSSFeed.Create;
begin
  FItems := TObjectList.Create;
end;

destructor TRSSFeed.Destroy;
begin
  FItems.Free;
end;

end.
